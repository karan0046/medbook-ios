//
//  User.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

struct User {
    let name: String
    let email: String
    let password: String
    let country: String
    
    init(name: String, email: String, password: String, country: String) {
        self.name = name
        self.email = email
        self.password = password
        self.country = country
    }
    
    init(user: User) {
        self.name = user.name
        self.email = user.email
        self.password = user.password
        self.country = user.country
    }
    
    init(json: [String: Any]) {
        self.name = json["name"] as? String ?? ""
        self.email = json["email"] as? String ?? ""
        self.password = json["password"] as? String ?? ""
        self.country = json["country"] as? String ?? ""
    }
    
    func toDic() -> [String: Any] {
        return [
            "name": name,
            "email": email,
            "password": password,
            "country": country
        ]
    }
    
}
