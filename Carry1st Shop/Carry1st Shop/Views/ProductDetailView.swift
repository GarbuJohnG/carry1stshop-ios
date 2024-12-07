//
//  ProductDetailView.swift
//  Carry1st Shop
//
//  Created by John Gachuhi on 05/12/2024.
//


import SwiftUI

struct ProductDetailView: View {
    
    @EnvironmentObject var viewModel: ProductViewModel
    
    @State private var showMaxItemsAlert: Bool = false
    
    let product: Product
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            if let url = URL(string: product.imageLocation) {
                CachedImageView(url: url, imageWidth: 200, imageHeight: 200)
                    .cornerRadius(10)
            } else {
                Rectangle()
                    .foregroundColor(Color(UIColor.systemGray5))
                    .frame(width: 200, height: 200)
                    .cornerRadius(10)
            }
            
            VStack(alignment: .leading, spacing: 16) {
                
                Text(product.description)
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                
                Text("\(product.currencySymbol)\(String(format: "%.2f", product.price))")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.green)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            Spacer()
            
            let cartQty = viewModel.cart.filter({ $0.id == product.id }).count
            
            if cartQty > 0 {
                alreadyInCarButton
                    .padding(.horizontal)
            } else {
                addCartButton
                    .padding(.horizontal)
            }
            
            buyButton
                .padding(.horizontal)
            
        }
        .padding()
        .navigationTitle(product.name)
        .navigationBarItems(
            trailing: NavigationLink(
                destination: CartView(viewModel: viewModel)
                    .toolbarRole(.editor)
            ) {
                Image(systemName: "cart.fill")
                    .foregroundColor(.primary)
                    .overlay(BadgeView(count: viewModel.cart.count))
            }
        )
        .alert("Maximum Quantity", isPresented: $showMaxItemsAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You can only add \(product.quantity) items to cart!")
        }
        
    }
    
    var buyButton: some View {
        
        Button(action: {
            print("Buy Now tapped for \(product.name)")
            
        }) {
            HStack {
                Image(systemName: "creditcard")
                Text("Buy Now")
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        
    }
    
    var addCartButton: some View {
        
        Button(action: {
            viewModel.addToCart(product: product)
        }) {
            HStack {
                Image(systemName: "cart.badge.plus")
                Text("Add to Cart")
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        
    }
    
    var alreadyInCarButton: some View {
        
        HStack {
            
            Button(action: {
                viewModel.removeFromCart(product: product)
            }) {
                
                ZStack {
                    
                    Color.red.opacity(0.4)
                        .frame(width: 50, height: 50)
                        .clipShape(.circle)
                    
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                    
                }
                
            }
            
            Spacer()
            
            Text("\(viewModel.cart.filter({ $0.id == product.id }).count)")
                .font(.system(size: 16, weight: .bold))
            
            Spacer()
            
            let cartQty = viewModel.cart.filter({ $0.id == product.id }).count
            
            Button(action: {
                if cartQty < product.quantity {
                    viewModel.addToCart(product: product)
                } else {
                    showMaxItemsAlert = true
                }
            }) {
                
                ZStack {
                    
                    Color.blue.opacity(0.4)
                        .frame(width: 50, height: 50)
                        .clipShape(.circle)
                    
                    Image(systemName: "plus")
                        .foregroundColor(.blue)
                    
                }
                .opacity(cartQty < product.quantity ? 1 : 0.3)
                
            }
            
        }
        
    }
    
}

#Preview {
    ContentView()
}
