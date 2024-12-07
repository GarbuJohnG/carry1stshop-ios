//
//  CartItem.swift
//  Carry1st Shop
//
//  Created by John Gachuhi on 07/12/2024.
//

import Foundation
import RealmSwift

class CartItemRealm: Object, Identifiable {
    
    @Persisted(primaryKey: true) var id: Int
    @Persisted var count: Int
    
    convenience init(id: Int, count: Int) {
        self.init()
        self.id = id
        self.count = count
    }
    
}
