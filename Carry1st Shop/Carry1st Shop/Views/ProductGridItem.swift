//
//  ProductGridItem.swift
//  Carry1st Shop
//
//  Created by John Gachuhi on 07/12/2024.
//

import SwiftUI

struct ProductGridItem: View {
    
    let product: Product
    
    let itemWidth: CGFloat
    let itemHeight: CGFloat
    
    var body: some View {
        
        ZStack {
            
            NavigationLink(destination: ProductDetailView(product: product)
                .toolbarRole(.editor)) {
                    
                ZStack {
                    
                    Color(UIColor.systemGray5)
                    
                    VStack {
                        
                        if let url = URL(string: product.imageLocation) {
                            CachedImageView(url: url, imageWidth: itemWidth - 40, imageHeight: itemHeight - 50)
                        } else {
                            Rectangle()
                                .foregroundColor(Color(UIColor.systemGray5))
                                .frame(width: itemWidth, height: itemHeight - 50)
                        }
                        
                        Spacer()
                    }
                    
                    VStack {
                        
                        Spacer()
                        
                        Text(product.name)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        Text("\(product.currencyCode) \(String(format: "%.2f", product.price))")
                            .font(.system(size: 15))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.horizontal,.bottom])
                        
                    }
                    .frame(width: itemWidth, height: itemHeight)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.clear, .clear, Color(UIColor.systemBackground)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    
                }
                    
            }
            
        }
        .frame(width: itemWidth, height: itemHeight)
        .cornerRadius(22)
        .shadow(radius: 3)
        
    }
    
}
