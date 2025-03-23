//
//  SessionManager.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 23/03/25.
//

import SwiftUI

class SessionManager: ObservableObject {
    @Published var isLoggedIn: Bool {
        didSet {
            UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
        }
    }
    @Published var isDatabaseCreated: Bool {
        didSet {
            UserDefaults.standard.set(isLoggedIn, forKey: "isDatabaseCreated")
        }
    }
    

    init() {
        self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        self.isDatabaseCreated = UserDefaults.standard.bool(forKey: "isDatabaseCreated")
        createDatabase()
    }
    
    private func createDatabase() {
        guard !isDatabaseCreated else { return }
        DBManager.instance.createDatabase()
        isDatabaseCreated = true
    }

    func login() {
        isLoggedIn = true
    }

    func logout() {
        isLoggedIn = false
    }
    
    deinit {
        print("SessionManager deallocated")
    }
}
