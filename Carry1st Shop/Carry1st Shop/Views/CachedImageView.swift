//
//  CachedImage.swift
//  Carry1st Shop
//
//  Created by John Gachuhi on 07/12/2024.
//

import SwiftUI

struct CachedImageView: View {
    
    let url: URL
    let imageWidth: CGFloat
    let imageHeight: CGFloat
    
    @StateObject private var imageLoader = ImageLoader()
    @Environment(\.scenePhase) var scenePhase

    init(url: URL, imageWidth: CGFloat, imageHeight: CGFloat) {
        self.url = url
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
    }

    var body: some View {
        content
            .onChange(of: scenePhase) {
                if scenePhase == .active {
                    imageLoader.load(url: url)
                }
            }
            .onAppear {
                imageLoader.load(url: url)
            }
    }
    
    private var content: some View {
        ZStack {
            switch imageLoader.image {
            case .loading:
                ProgressView()
                    .frame(width: imageWidth, height: imageHeight, alignment: .center)
            case .success(let image):
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imageWidth, height: imageHeight, alignment: .center)
            case .failure:
                Color.gray
                    .opacity(0.5)
                    .frame(width: imageWidth, height: imageHeight, alignment: .center)
            }
        }
    }

}
