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
    @State private var isPasswordVisible = false
    var validationRequired: Bool
    
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
                        .textContentType(.oneTimeCode)
                } else {
                    SecureField("Password", text: $password)
                        .onChange(of: password) { oldValue, newValue in
                            guard validationRequired else { return }
                            isValidPassword = validatePassword(newValue).isValid
                        }
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .textContentType(.oneTimeCode)
                }
                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity)
            .overlay(
                Rectangle()
                    .frame(maxHeight: 2)
                    .foregroundColor(
                        Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
                    ),
                alignment: .bottom
            )
            .padding(EdgeInsets(top: 30, leading: 20, bottom: 10, trailing: 20))
            
            if validationRequired {
                VStack(alignment: .leading, spacing: 6) {
                    let validationResult = validatePassword(password)
                    RequirementRow(label: "At least 1 Uppercase", isMet: validationResult.hasUppercase)
                    RequirementRow(label: "At least 1 number", isMet: validationResult.hasNumber)
                    RequirementRow(label: "Special character", isMet: validationResult.hasSpecialCharacter)
                    RequirementRow(label: "Atleast 8 characters", isMet: validationResult.isMinLength)
                }
            }
        }
    }
    
    private func validatePassword(_ password: String) -> PasswordValidationResult {
        return PasswordValidationResult(
            hasUppercase: password.range(of: "[A-Z]", options: .regularExpression) != nil,
            hasNumber: password.range(of: "\\d", options: .regularExpression) != nil,
            hasSpecialCharacter: password.range(of: "[\\W_]", options: .regularExpression) != nil,
            isMinLength: password.count >= 8
        )
    }
}
