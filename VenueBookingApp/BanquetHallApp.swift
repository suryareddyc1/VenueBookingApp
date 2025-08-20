//
//  BanquetHallApp.swift
//  BanquetHallApp
//
//  Created by Surya Vummadi on 03/06/25.
//

import SwiftUI

@main
struct BanquetHallApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
