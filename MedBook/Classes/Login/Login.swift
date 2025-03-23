//
//  Login.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 23/03/25.
//

struct Login {
    var email: String
    var password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    init() {
        self.email = ""
        self.password = ""
    }
}
