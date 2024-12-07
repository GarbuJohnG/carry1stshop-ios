//
//  ProductDetailView.swift
//  Carry1st Shop
//
//  Created by John Gachuhi on 05/12/2024.
//


import SwiftUI

struct ProductDetailView: View {
    
    @EnvironmentObject var viewModel: ProductViewModel
    
    let product: Product
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            AsyncImage(url: URL(string: product.imageLocation)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
            } placeholder: {
                ZStack {
                    Rectangle()
                        .foregroundStyle(.placeholder)
                        .frame(width: 200, height: 200)
                        .cornerRadius(3)
                    
                    ProgressView()
                }
            }
            
            VStack(alignment: .leading, spacing: 16) {
                
                Text(product.description)
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
                
                Text("\(product.currencySymbol)\(String(format: "%.2f", product.price))")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.green)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            Spacer()
            
            addCartButton
                .padding(.horizontal)
            
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
                    .foregroundStyle(.primary)
                    .overlay(BadgeView(count: viewModel.cart.count))
            }
        )
        
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
            .foregroundStyle(.white)
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
            .foregroundStyle(.white)
            .cornerRadius(10)
        }
        
    }
    
}
