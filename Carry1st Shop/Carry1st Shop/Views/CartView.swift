//
//  CartView.swift
//  Carry1st Shop
//
//  Created by John Gachuhi on 05/12/2024.
//


import SwiftUI

struct CartView: View {
    
    @ObservedObject var productVM: ProductViewModel
    
    @State private var showMaxItemsAlert: Bool = false
    
    var body: some View {
        
        ZStack {
            
            if productVM.cart.isEmpty {
                
                EmptyListView()
                
            } else {
                
                List(productVM.cart) { cartItem in
                    
                    let count = cartItem.count
                    if let product = productVM.products.first(where: { $0.id == cartItem.id }) {
                        CartItemView(count: count, product: product)
                            .padding(.vertical, 5)
                    }
                    
                }
            }
            
            VStack(spacing: 20) {
        
                if productVM.totalPrice > 0 {
        
                    totalLabel
        
                }
        
                chekoutButton
        
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.horizontal)
            
        }
        .navigationTitle("Cart")
        
    }
    
    var chekoutButton: some View {
        
        Button(action: {
            
            if productVM.itemsCount > 0 {
                productVM.clearCart()
                productVM.makePurchase()
            } else {
                productVM.isErrorEncountered = true
                productVM.errorMessage = "No items in cart to checkout, go back to products page to add some."
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    self.productVM.isErrorEncountered = false
                    self.productVM.errorMessage = nil
                })
            }
            
        }) {
            HStack {
                Image(systemName: "cart.badge.plus")
                Text("Checkout")
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green.opacity(productVM.itemsCount > 0 ? 1 : 0.7))
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        
    }
    
    var totalLabel: some View {
        HStack {
            
            Text("Total")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.primary)
            
            Spacer()
            
            Text("USD \(String(format: "%.2f", productVM.totalPrice))") // Currency hardcoded assuming there is a global currency one gets with the Products
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.primary)
            
        }
    }
    
    func CartItemView(count: Int, product: Product) -> some View {
        
        HStack {
            
            VStack(alignment: .leading) {
                
                Text(product.name)
                    .font(.headline)
                
                Text(product.description)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                
            }
            
            Spacer()
            
            Text("@ \(product.currencySymbol)\(String(format: "%.2f", product.price))")
                .font(.system(size: 13))
                .foregroundColor(.secondary)
            
            HStack {
                
                Button(action: {
                    productVM.removeFromCart(productID: product.id)
                }) {
                    
                    ZStack {
                        
                        Color.red.opacity(0.4)
                            .frame(width: 30, height: 30)
                            .clipShape(.circle)
                        
                        Image(systemName: "minus")
                            .foregroundColor(.red)
                        
                    }
                    
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                Text("\(productVM.cart.first(where: { $0.id == product.id })?.count ?? 0)")
                    .font(.system(size: 16, weight: .bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                Spacer()
                
                let cartQty = productVM.cart.first(where: { $0.id == product.id })?.count ?? 0
                
                Button(action: {
                    if cartQty < product.quantity {
                        productVM.addToCart(productID: product.id)
                    } else {
                        showMaxItemsAlert = true
                    }
                }) {
                    
                    ZStack {
                        
                        Color.blue.opacity(0.4)
                            .frame(width: 30, height: 30)
                            .clipShape(.circle)
                        
                        Image(systemName: "plus")
                            .foregroundColor(.blue)
                        
                    }
                    .opacity(cartQty < product.quantity ? 1 : 0.3)
                    
                }
                .buttonStyle(PlainButtonStyle())
                
            }
            .frame(maxWidth: 110)
            
        }
        .alert("Maximum Quantity", isPresented: $showMaxItemsAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You can only add \(product.quantity) \(product.name)s to cart!")
        }
        
    }
    
}

//#Preview {
//    ContentView()
//}
