//
//  PasswordValidationResult.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 20/03/25.
//

struct PasswordValidationResult {
    var hasUppercase: Bool
    var hasNumber: Bool
    var hasSpecialCharacter: Bool
    var isMinLength: Bool
    
    var isValid: Bool {
        hasUppercase && hasNumber && hasSpecialCharacter && isMinLength
    }
}
