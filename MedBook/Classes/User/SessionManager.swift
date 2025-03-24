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

    init() {
        self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        self.createDatabase()
    }
    
    private func createDatabase() {
        DBManager.instance.createDatabase()
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
