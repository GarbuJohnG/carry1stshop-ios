//
//  BannerView.swift
//  Carry1st Shop
//
//  Created by John Gachuhi on 07/12/2024.
//

import SwiftUI

struct BannerView: View {
    
    let message: String
    var bgColor: Color = .red

    var body: some View {
        
        Text(message)
            .foregroundColor(.white)
            .padding()
            .background(bgColor)
            .cornerRadius(8)
            .shadow(radius: 5)
            .frame(maxWidth: .infinity)
            .padding()
        
    }
}
