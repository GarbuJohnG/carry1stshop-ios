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
                    
                    List(viewModel.products) { product in
                        ProductRowView(product: product)
                    }
                    .refreshable {
                        viewModel.fetchProducts()
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
                        .foregroundStyle(.blue)
                        .overlay(BadgeView(count: viewModel.cart.count))
                }
            )
            
        }
        .environmentObject(viewModel)
        
    }
}

#Preview {
    ContentView()
}
