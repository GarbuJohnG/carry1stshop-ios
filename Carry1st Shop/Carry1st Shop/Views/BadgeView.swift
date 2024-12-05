//
//  BadgeView.swift
//  Carry1st Shop
//
//  Created by John Gachuhi on 05/12/2024.
//

import SwiftUI

struct BadgeView: View {
    
    let count: Int
    
    var body: some View {
        
        ZStack(alignment: .topTrailing) {
            
            Color.clear
            
            if count > 0 {
                Text(String(count))
                    .font(.system(size: 12))
                    .foregroundStyle(.white)
                    .scaledToFill()
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .frame(width: 22, height: 22)
                    .background(Color.red)
                    .clipShape(Circle())
                    .alignmentGuide(.top) { $0[.bottom] - $0.height * 0.15 }
                    .alignmentGuide(.trailing) { $0[.trailing] - $0.width * 0.25 }
            }
            
        }
    }
}
