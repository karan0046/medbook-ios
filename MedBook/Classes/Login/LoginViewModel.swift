//
//  LoginViewModel.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

import SwiftUI

@MainActor
class LoginViewModel: ObservableObject {
    @Published var processing: Bool = false
    @Published var validCreds: Bool = false
    
    init() {
        
    }
    
    func checkValidCreds(_ loginCreds: Login) async {
        processing = true
        guard let record = await Table.Auth.fetch(withId: loginCreds.email) else {
            processing = false
            validCreds = false
            return
        }
        guard let recordPassword = record["password"] as? String, loginCreds.password == recordPassword else {
            processing = false
            validCreds = false
            return
        }
        resetCurrentUser(User(json: record))
        processing = false
        validCreds = true
    }
    
    private func resetCurrentUser(_ user: User) {
        Task {
            await Table.CurrentUser.deleteAll(filters: nil) { success, error in
                guard success else {
                    print(error as Any)
                    return
                }
                Task {
                    await Table.CurrentUser.insert(withJson: user.toDic(), docId: user.email) { success, error in
                        guard success else {
                            print(error as Any)
                            return
                        }
                        CurrentUser.shared.profile = user
                    }
                }
            }
        }
    }
    
    deinit {
        print("LoginViewModel deallocated")
    }
}
