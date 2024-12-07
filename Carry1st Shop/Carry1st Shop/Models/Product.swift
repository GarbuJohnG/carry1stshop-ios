//
//  Product.swift
//  Carry1st Shop
//
//  Created by John Gachuhi on 05/12/2024.
//

import Foundation
import RealmSwift

struct Product: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let description: String
    let price: Double
    let currencyCode: String
    let currencySymbol: String
    let quantity: Int
    let imageLocation: String
    let status: String
}

class ProductRealm: Object, Identifiable {
    
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var descriptionText: String
    @Persisted var price: Double
    @Persisted var currencyCode: String
    @Persisted var currencySymbol: String
    @Persisted var quantity: Int
    @Persisted var imageLocation: String
    @Persisted var status: String

    // Convert Codable Product to Realm Object
    convenience init(from product: Product) {
        self.init()
        self.id = product.id
        self.name = product.name
        self.descriptionText = product.description
        self.price = product.price
        self.currencyCode = product.currencyCode
        self.currencySymbol = product.currencySymbol
        self.quantity = product.quantity
        self.imageLocation = product.imageLocation
        self.status = product.status
    }

    // Convert Realm Object to Codable Product
    func toProduct() -> Product {
        return Product(
            id: id,
            name: name,
            description: descriptionText,
            price: price,
            currencyCode: currencyCode,
            currencySymbol: currencySymbol,
            quantity: quantity,
            imageLocation: imageLocation,
            status: status
        )
    }
    
}

