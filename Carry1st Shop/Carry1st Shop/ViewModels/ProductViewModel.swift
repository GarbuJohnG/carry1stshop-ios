//
//  ProductViewModel.swift
//  Carry1st Shop
//
//  Created by John Gachuhi on 05/12/2024.
//

import SwiftUI
import RealmSwift
import Network

class ProductViewModel: ObservableObject {
    
    @Published var products: [Product] = []
    @Published var cart: [CartItemRealm] = []
    
    @Published var isErrorEncountered = false // Private setting removed to aid in access from the View layer to aid in Testing
    @Published private(set) var isOffline = false
    @Published private(set) var isLoading = false
    @Published private(set) var isPurchaseMade = false
    @Published var errorMessage: String? // Private setting removed to aid in access from the View layer to aid in Testing
    @Published private(set) var totalPrice: Double = 0.0
    @Published private(set) var itemsCount: Int = 0
    
    private let realm = try? Realm()
    private let networkService = NetworkService()
    private let monitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "NetworkMonitor")

    init() {
        loadOfflineProducts()
        fetchCartFromLocalDb()
        calculateTotalPrice()
        calculateTotalItems()
        startNetworkMonitoring()
        fetchProducts()
    }

    private func loadOfflineProducts() {
        guard let realm = realm else {
            print("Invalid Realm DB Instance")
            return
        }
        let realmProducts = realm.objects(ProductRealm.self)
        products = realmProducts.map { $0.toProduct() }
    }
    
    func fetchCartFromLocalDb() {
        guard let realm = realm else {
            print("Invalid Realm DB Instance")
            return
        }
        let realmCartItems = realm.objects(CartItemRealm.self)
        cart = Array(realmCartItems)
    }

    func fetchProducts() {
        isLoading = true
        networkService.fetchData(endpoint: Constants.EndPoints.getProducts, responseType: [Product].self) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let fetchedProducts):
                    self?.updateLocalProductDb(with: fetchedProducts)
                case .failure(let error):
                    self?.isOffline = true
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    private func startNetworkMonitoring() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isOffline = path.status != .satisfied
            }
        }
        monitor.start(queue: monitorQueue)
    }
    
    // MARK: Cart Functions
    
    func addToCart(productID: Int) {
        guard let realm = realm else {
            print("Invalid Realm DB Instance")
            return
        }
        if let index = cart.firstIndex(where: { $0.id == productID }) {
            do {
                try realm.write {
                    cart[index].count += 1
                }
            } catch {
                print("Error saving to Realm: \(error)")
            }
            updateCartItemQuantity(id: cart[index].id, count: cart[index].count)
        } else {
            do {
                try realm.write {
                    cart.append(CartItemRealm(id: productID, count: 1))
                }
            } catch {
                print("Error saving to Realm: \(error)")
            }
            updateCartItemQuantity(id: productID, count: 1)
        }
        calculateTotalPrice()
        calculateTotalItems()
    }

    func removeFromCart(productID: Int) {
        guard let realm = realm else {
            print("Invalid Realm DB Instance")
            return
        }
        if let index = cart.firstIndex(where: { $0.id == productID }) {
            if cart[index].count > 1 {
                do {
                    try realm.write {
                        cart[index].count -= 1
                    }
                } catch {
                    print("Error saving to Realm: \(error)")
                }
                updateCartItemQuantity(id: cart[index].id, count: cart[index].count)
            } else {
                removeCartItem(id: cart[index].id)
                do {
                    try realm.write {
                        cart.remove(at: index)
                    }
                } catch {
                    print("Error saving to Realm: \(error)")
                }
            }
        }
        calculateTotalPrice()
        calculateTotalItems()
    }
    
    func clearCart() {
        
        totalPrice = 0.0
        itemsCount = 0
        
        guard let realm = realm else {
            print("Invalid Realm DB Instance")
            return
        }
        do {
            try realm.write {
                cart.removeAll()
            }
            removeLocalCartDb()
        } catch {
            print("Error saving to Realm: \(error)")
        }
        
    }
    
    // MARK: Purchase has been made
    
    func makePurchase() {
        
        isPurchaseMade = true
        
        // This will close the Success purchase message after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.isPurchaseMade = false
        })
        
    }
    
    // MARK: Calculate Cart Numbers
    
    private func calculateTotalPrice() {
        var totalPrice = 0.0
        for each in cart {
            let product = products.first(where: { $0.id == each.id })
            totalPrice += ((product?.price ?? 0) * Double(each.count))
        }
        self.totalPrice = totalPrice
    }
    
    private func calculateTotalItems() {
        var itemsCount = 0
        for each in cart {
            itemsCount += each.count
        }
        self.itemsCount = itemsCount
    }
    
    // MARK: RealmDB Functions
    
    /// This replaces the current local database of products with the newest one got from the API call
    /// - Parameter newProducts: This are the new products got from the API call
    private func updateLocalProductDb(with newProducts: [Product]) {
        guard let realm = realm else {
            print("Invalid Realm DB Instance")
            return
        }
        do {
            try realm.write {
                
                let oldProducts = realm.objects(ProductRealm.self)
                realm.delete(oldProducts)
                for product in newProducts {
                    let realmProduct = ProductRealm(from: product)
                    realm.add(realmProduct)
                }
            }
            products = newProducts
        } catch {
            print("Error saving to Realm: \(error)")
        }
    }
    
    
    /// This removes the contents of the cart in the local Realm DB
    private func removeLocalCartDb() {
        guard let realm = realm else {
            print("Invalid Realm DB Instance")
            return
        }
        do {
            try realm.write {
                let oldCartItems = realm.objects(CartItemRealm.self)
                realm.delete(oldCartItems)
            }
        } catch {
            print("Error saving to Realm: \(error)")
        }
    }
    
    /// This updated a selected cart item from the local realm DB
    /// - Parameters:
    ///   - id: ID for the cart item to be updated
    ///   - count: Number of items to be updated
    private func updateCartItemQuantity(id: Int, count: Int) {
        guard let realm = realm else {
            print("Invalid Realm DB Instance")
            return
        }
        if let cartItem = realm.object(ofType: CartItemRealm.self, forPrimaryKey: id) {
            // Record found and thus updated
            do {
                try realm.write {
                    cartItem.count = count
                }
            } catch {
                print("Error saving to Realm: \(error)")
            }
        } else {
            // Record not found and thus a new one added
            do {
                try realm.write {
                    realm.add(CartItemRealm(id: id, count: count))
                }
            } catch {
                print("Error saving to Realm: \(error)")
            }
        }
    }
    
    /// This removes the cart Item from the local realm DB
    /// - Parameter id: ID for the cart item to be deleted
    private func removeCartItem(id: Int) {
        guard let realm = realm else {
            print("Invalid Realm DB Instance")
            return
        }
        if let itemToDelete = realm.object(ofType: CartItemRealm.self, forPrimaryKey: id) {
            do {
                try realm.write {
                    realm.delete(itemToDelete)
                }
            } catch {
                print("Error saving to Realm: \(error)")
            }
        } else {
            print("Item with id \(id) not found.")
        }
    }
    
}

