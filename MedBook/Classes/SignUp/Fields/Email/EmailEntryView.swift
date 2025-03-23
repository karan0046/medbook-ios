//
//  Untitled.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

import SwiftUI

struct EmailEntryView: View {
    @Binding var email: String
    @Binding var isValidEmail: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Email", text: $email)
                .frame(maxWidth: .infinity)
                .onChange(of: email) { oldValue, newValue in
                    isValidEmail = isValidEmailFormat(newValue)
                }
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .textContentType(.newPassword)
                .overlay(
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: 2)
                        .foregroundColor(
                            Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
                        ),
                    alignment: .bottom
                )
                .padding(EdgeInsets(top: 30, leading: 20, bottom: 10, trailing: 20))
            
            if !email.isEmpty {
                Text(isValidEmail ? "" : "Invalid email format")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
    }
    
    private func isValidEmailFormat(_ email: String) -> Bool {
        guard !email.isEmpty else { return false }
        let emailRegex = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES[c] %@", emailRegex).evaluate(with: email)
    }
}
