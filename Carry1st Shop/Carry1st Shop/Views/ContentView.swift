//
//  ContentView.swift
//  Carry1st Shop
//
//  Created by John Gachuhi on 03/12/2024.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ProductViewModel()

    var body: some View {
        
        NavigationView {
            
            VStack {
                
                if viewModel.isLoading {
                    
                    ProgressView("Loading...")
                    
                } else if let errorMessage = viewModel.errorMessage {
                    
                    EmptyListView(message: "Error: \(errorMessage)")
                    
                } else {
                    
                    GeometryReader { geometry in
                        
                        let screenWidth = geometry.size.width
                        let itemWidth = (screenWidth - 40) / 2
                        let itemHeight = itemWidth * 4 / 3
                        
                        ScrollView {
                            
                            LazyVGrid(columns: [
                                GridItem(.fixed(itemWidth), spacing: 16),
                                GridItem(.fixed(itemWidth), spacing: 16)
                            ], spacing: 16) {
                                
                                ForEach(viewModel.products) { product in
                                    
                                    ProductGridItem(product: product, itemWidth: itemWidth, itemHeight: itemHeight)
                                    
                                }
                                
                            }
                            .padding(.horizontal, 15)
                            
                        }
                    }
                    
                }
                
            }
            .navigationTitle("Products")
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
            
        }
        .environmentObject(viewModel)
        
    }
}


