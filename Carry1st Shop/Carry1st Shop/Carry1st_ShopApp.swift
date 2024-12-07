//
//  Carry1st_ShopApp.swift
//  Carry1st Shop
//
//  Created by John Gachuhi on 03/12/2024.
//

import SwiftUI
import CoreData

@main
struct Carry1st_ShopApp: App {
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

final class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "Carry1stModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load Core Data: \(error)")
            }
        }
    }
}
