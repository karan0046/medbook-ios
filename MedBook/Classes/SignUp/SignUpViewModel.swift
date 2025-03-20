//
//  SignUpViewModel.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

import SwiftUI

@MainActor
class SignUpViewModel: ObservableObject {
    @Published var processing: Bool = false
    @Published var isValidUser: Bool = true
    @Published var signUpCompletion: ((Bool, Error?) -> Void)? 

    init() {}

    func createUserAndLogin(_ user: User) async {
        processing = true
        await validateUser(user)

        guard isValidUser else {
            processing = false
            signUpCompletion?(false, NSError(domain: "User already exists", code: 409, userInfo: nil))
            return
        }

        await Table.Auth.insert(withJson: user.toDic(), docId: user.email) { success, error in
            if success {
                resetCurrentUser(user)
            } else {
                print(error as Any)
            }
            signUpCompletion?(success, error)
        }
        processing = false
    }

    private func validateUser(_ user: User) async {
        let userExits = await Table.Auth.exists(withId: user.email)
        isValidUser = !userExits
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
        print("SignUpViewModel deallocated")
    }
}
