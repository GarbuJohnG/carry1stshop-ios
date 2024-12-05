//
//  ProductRowView.swift
//  Carry1st Shop
//
//  Created by John Gachuhi on 05/12/2024.
//


import SwiftUI

struct ProductRowView: View {
    
    @EnvironmentObject var viewModel: ProductViewModel
    let product: Product
    
    var body: some View {
        
        NavigationLink(destination: ProductDetailView(product: product)
            .toolbarRole(.editor)) {
            HStack {
                
                AsyncImage(url: URL(string: product.imageLocation)) { image in
                    
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    
                } placeholder: {
                    ZStack {
                        
                        Rectangle()
                            .foregroundStyle(.placeholder)
                            .frame(width: 50, height: 50)
                            .cornerRadius(3)
                        
                        ProgressView()
                        
                    }
                }
                
                VStack(alignment: .leading) {
                    
                    Text(product.name)
                        .font(.headline)
                    Text("\(product.currencySymbol)\(String(format: "%.2f", product.price))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                }
                
                Spacer()
                
            }
        }
        
        
    }
    
}
