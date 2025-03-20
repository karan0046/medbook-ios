//
//  CurrentUser.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

class CurrentUser {
    static let shared = CurrentUser()
    var profile: User?
    
    init(profile: User? = nil) {
        self.profile = profile
    }
}
