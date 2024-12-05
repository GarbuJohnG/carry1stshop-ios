//
//  CartView.swift
//  Carry1st Shop
//
//  Created by John Gachuhi on 05/12/2024.
//


import SwiftUI

struct CartView: View {
    
    @ObservedObject var viewModel: ProductViewModel
    
    var body: some View {
        
        let uniqueItemCounts = viewModel.cart.reduce(into: [:]) { counts, item in
            counts[item, default: 0] += 1
        }
        
        ZStack {
            
            if uniqueItemCounts.isEmpty {
                
                EmptyListView()
                
            } else {
                
                List(Array(uniqueItemCounts.keys), id: \.id) { product in
                    
                    HStack {
                        
                        let count = uniqueItemCounts[product] ?? 0
                        
                        VStack(alignment: .leading) {
                            
                            Text(product.name)
                                .font(.headline)
                            
                            Text(product.description)
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                            
                        }
                        
                        Spacer()
                        
                        Stepper(value: Binding(
                            get: { uniqueItemCounts[product] ?? 0 },
                            set: { newValue in
                                let currentCount = uniqueItemCounts[product] ?? 0
                                if newValue > currentCount {
                                    viewModel.addToCart(product: product)
                                } else if newValue < currentCount {
                                    viewModel.removeFromCart(product: product)
                                }
                            }
                        ), in: 0...100) {
                            Text("Qty: \(count)")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                        }
                        .frame(width: 150)
                        
                    }
                    .padding(.vertical, 5)
                }
            }
            
            chekoutButton
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.horizontal)
            
        }
        .navigationTitle("Cart")
        
    }
    
    var chekoutButton: some View {
        
        Button(action: {
            print("Checkout Now")
            
        }) {
            HStack {
                Image(systemName: "cart.badge.plus")
                Text("Checkout")
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .foregroundStyle(.white)
            .cornerRadius(10)
        }
        
    }
    
}
