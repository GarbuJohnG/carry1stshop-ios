//
//  LocalFileManager.swift
//  Carry1st Shop
//
//  Created by John Gachuhi on 07/12/2024.
//


import Foundation
import SwiftUI

class LocalFileManager {
    
    static let shared = LocalFileManager()
    
    private init() {}
    
    /// Saves Image Locally for persistence
    /// - Parameters:
    ///   - image: Image to be saved
    ///   - imageName: Name of image to be saved
    ///   - folderName: Folder where image will be saved
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        // Folder creation
        createFolderIfNeeded(folderName: folderName)
        // Get Image Path
        guard let data = image.pngData(),
              let url = getUrlForImage(imageName: imageName, folderName: folderName)
        else { return }
        // Write Image data to Path
        do {
            try data.write(to: url)
        } catch let error {
            print("Error occured saving \(imageName) image. ERROR: \(error)")
        }
    }
    
    /// Get Image stored Locally
    /// - Parameters:
    ///   - imageName: Name of Image to be retreived
    ///   - folderName: Folder name of where image is saved
    /// - Returns: Returns image as UIImage stored locally in the app
    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard let url = getUrlForImage(imageName: imageName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
    }
    
    // MARK: - Private Funtions
    
    /// Create a folder name in case it does not already exist
    /// - Parameter folderName: Name of folder to be created
    private func createFolderIfNeeded(folderName: String) {
        guard let folderUrl = getUrlForFolder(folderName: folderName) else { return }
        if !FileManager.default.fileExists(atPath: folderUrl.path) {
            do {
                try FileManager.default.createDirectory(at: folderUrl, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error occured creating \(folderName) directory. ERROR: \(error)")
            }
        }
    }
    
    /// Get the URL for folder whose name is specified
    /// - Parameter folderName: Name of the folder whose URL we are getting
    /// - Returns: URL of the folder
    private func getUrlForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(folderName)
    }
    
    
    /// Get the URL for image whose name is specified
    /// - Parameters:
    ///   - imageName: Name of the image whose URL we are getting
    ///   - folderName: Name of the folder whose URL we are getting
    /// - Returns: URL of the image
    private func getUrlForImage(imageName: String, folderName: String) -> URL? {
        guard let folderUrl = getUrlForFolder(folderName: folderName) else {
            return nil
        }
        return folderUrl.appendingPathComponent(imageName)
    }
    
}
