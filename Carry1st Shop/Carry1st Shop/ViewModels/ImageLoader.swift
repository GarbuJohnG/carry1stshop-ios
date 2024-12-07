//
//  ImageLoader.swift
//  Carry1st Shop
//
//  Created by John Gachuhi on 07/12/2024.
//

import SwiftUI
import CryptoKit

class ImageLoader: ObservableObject {
    
    enum ImageState {
        case loading, success(Image), failure
    }

    @Published private(set) var image: ImageState = .loading

    private let fileManager = LocalFileManager.shared
    private let folderName = "cached_images"

    
    /// This function loads imaged either from the Local storage if already cached or from the URLSession if not yet cached
    /// - Parameter url: This is the url from which the image is downloaded and saved under in the cache
    func load(url: URL) {
        
        let inputData = Data(url.absoluteString.utf8)
        let hashed = SHA256.hash(data: inputData)
        let imageName = hashed.description
        
        if let savedimage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = .success(Image(uiImage: savedimage))
            return
        } else {
            image = .loading
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let self = self else { return }
                if let _ = error {
                    DispatchQueue.main.async {
                        self.image = .failure
                    }
                } else if let data = data, let uiImage = UIImage(data: data) {
                    self.fileManager.saveImage(image: uiImage, imageName: imageName, folderName: folderName)
                    DispatchQueue.main.async {
                        self.image = .success(Image(uiImage: uiImage))
                    }
                }
            }.resume()
        }
    }
}
