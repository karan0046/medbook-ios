//
//  LaunchScreenViewModel.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

import SwiftUI

@MainActor
class LaunchScreenViewModel: ObservableObject {
    
    @Published var userLoggedIn: Bool = false
    
    init() {
        validateLogin()
    }
    
    func validateLogin() {
        Task {
            let currentUserRecords = await Table.CurrentUser.fetchAll(filters: nil, sortBy: nil, offset: nil, limit: nil)
            await MainActor.run {
                if !currentUserRecords.isEmpty, let user = currentUserRecords.first {
                    userLoggedIn = true
                    CurrentUser.shared.profile = User(json: user)
                } else {
                    userLoggedIn = false
                }
            }
        }
    }
    
    deinit {
        print("LaunchScreenViewModel deallocated")
    }
}
