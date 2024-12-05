//
//  EmptyListView.swift
//  Carry1st Shop
//
//  Created by John Gachuhi on 05/12/2024.
//


import SwiftUI

struct EmptyListView: View {
    
    var message: String = "Ooops...so empty in here"
    
    var body: some View {
        VStack(spacing: 20) {
            
            Image(systemName: "tray")
                .font(.system(size: 50, weight: .bold))
                .foregroundColor(.gray)
            
            Text(message)
                .font(.system(size: 15))
                .foregroundColor(.gray)
            
        }
    }
    
}
