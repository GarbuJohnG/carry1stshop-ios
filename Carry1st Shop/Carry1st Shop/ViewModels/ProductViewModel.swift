//
//  ProductViewModel.swift
//  Carry1st Shop
//
//  Created by John Gachuhi on 05/12/2024.
//

import SwiftUI

class ProductViewModel: ObservableObject {
    
    @Published private(set) var products: [Product] = []
    @Published private(set) var cart: [Product] = []
    @Published private(set) var isLoading = false
    @Published private(set)var errorMessage: String?
    
    private let networkService = NetworkService()
    
    init() {
        fetchProducts()
    }

    func fetchProducts() {
        
        isLoading = true
        errorMessage = nil

        networkService.fetchData(endpoint: Constants.EndPoints.getProducts, responseType: [Product].self) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let products):
                    self?.products = products
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
        
        
    }

    func addToCart(product: Product) {
        cart.append(product)
    }

    func removeFromCart(product: Product) {
        if let index = cart.firstIndex(where: { $0.id == product.id }) {
            cart.remove(at: index)
        }
    }
    
}
