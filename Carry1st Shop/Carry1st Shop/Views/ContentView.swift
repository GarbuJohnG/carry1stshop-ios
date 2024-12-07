//
//  ContentView.swift
//  Carry1st Shop
//
//  Created by John Gachuhi on 03/12/2024.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var productVM = ProductViewModel()

    var body: some View {
        
        NavigationView {
            
            VStack {
                
                if productVM.isLoading {
                    
                    ProgressView("Loading...")
                    
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
                                
                                ForEach(productVM.products) { product in
                                    
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
                leading: Image("Carry1st-logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 20)
                    .foregroundColor(.primary),
                trailing: NavigationLink(
                        destination: CartView(productVM: productVM)
                            .toolbarRole(.editor)
                    ) {
                        Image(systemName: "cart.fill")
                            .foregroundColor(.primary)
                            .overlay(BadgeView(count: productVM.itemsCount))
                    }
            )
            
        }
        .overlay(
            productVM.isOffline ? BannerView(message: "You are offline") : nil,
            alignment: .top
        )
        .overlay(
            productVM.isPurchaseMade ? BannerView(message: "Congratulations on your purchase!", bgColor: .green) : nil,
            alignment: .top
        )
        .overlay(
            productVM.isErrorEncountered ? BannerView(message: productVM.errorMessage ?? "") : nil,
            alignment: .top
        )
        .environmentObject(productVM)
        
    }
}
//
//#Preview {
//    ContentView()
//}




