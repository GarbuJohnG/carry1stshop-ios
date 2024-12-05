//
//  Product.swift
//  Carry1st Shop
//
//  Created by John Gachuhi on 05/12/2024.
//

import Foundation

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
