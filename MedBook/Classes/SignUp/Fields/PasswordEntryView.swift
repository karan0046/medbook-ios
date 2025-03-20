//
//  PasswordEntryView.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

import SwiftUI

struct PasswordEntryView: View {
    @Binding var password: String
    @Binding var isValidPassword: Bool
    var validationRequired: Bool
    
    @State private var isPasswordVisible = false
    
    
    var body: some View {
        VStack {
            HStack {
                if isPasswordVisible {
                    TextField("Password", text: $password)
                        .onChange(of: password) { oldValue, newValue in
                            guard validationRequired else { return }
                            isValidPassword = validatePassword(newValue).isValid
                        }
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                } else {
                    SecureField("Password", text: $password)
                        .onChange(of: password) { oldValue, newValue in
                            guard validationRequired else { return }
                            isValidPassword = validatePassword(newValue).isValid
                        }
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        
                }
                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                        .foregroundColor(.gray)
                }
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .padding(.top, 30)
            .overlay(
                Rectangle()
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .frame(maxWidth: .infinity, maxHeight: 2)
                    .foregroundColor(
                        Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
                    ),
                alignment: .bottom
            )
            
            if validationRequired {
                VStack(alignment: .leading, spacing: 6) {
                    let validationResult = validatePassword(password)
                    RequirementRow(label: "At least 1 Uppercase", isMet: validationResult.hasUppercase)
                    RequirementRow(label: "At least 1 number", isMet: validationResult.hasNumber)
                    RequirementRow(label: "Special character", isMet: validationResult.hasSpecialCharacter)
                    RequirementRow(label: "Atleast 8 characters", isMet: validationResult.isMinLength)
                }
                .padding()
            }
        }
    }
    
    func validatePassword(_ password: String) -> PasswordValidationResult {
        return PasswordValidationResult(
            hasUppercase: password.range(of: "[A-Z]", options: .regularExpression) != nil,
            hasNumber: password.range(of: "\\d", options: .regularExpression) != nil,
            hasSpecialCharacter: password.range(of: "[\\W_]", options: .regularExpression) != nil,
            isMinLength: password.count >= 8
        )
    }
}

struct PasswordValidationResult {
    var hasUppercase: Bool
    var hasNumber: Bool
    var hasSpecialCharacter: Bool
    var isMinLength: Bool
    
    var isValid: Bool {
        hasUppercase && hasNumber && hasSpecialCharacter && isMinLength
    }
}

struct RequirementRow: View {
    let label: String
    let isMet: Bool

    var body: some View {
        HStack() {
            Image(systemName: isMet ? "checkmark.square" : "square")
                .foregroundColor(isMet ? .green : Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
            Text(label)
                .foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
        }
    }
}
