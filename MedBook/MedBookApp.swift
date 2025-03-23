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
    @StateObject private var sessionManager = SessionManager()

    var body: some Scene {
        WindowGroup {
            if sessionManager.isLoggedIn {
                HomeView()
                    .preferredColorScheme(.light)
                    .environmentObject(sessionManager)
            } else {
                LaunchScreenView()
                    .preferredColorScheme(.light)
                    .environmentObject(sessionManager)
            }
            
        }
    }
}
