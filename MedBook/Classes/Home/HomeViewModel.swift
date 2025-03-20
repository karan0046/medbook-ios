//
//  HomeViewModel.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var logoutSuccess: Bool = false
    
    init() {
        
    }
    
    func logOut() async {
        logoutSuccess = false
        await Table.CurrentUser.deleteAll(filters: nil) { success, error in
            guard success else {
                print(error as Any)
                return
            }
            CurrentUser.shared.profile = nil
        }
        logoutSuccess = true
    }
    
    deinit {
        print("HomeViewModel deallocated")
    }
}
