//
//  MedBookApp.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

import SwiftUI

@main
struct MedBookApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
