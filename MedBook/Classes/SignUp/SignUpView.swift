//
//  SignUpView.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

import SwiftUI


struct SignUpView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @Environment(\.dismiss) private var dismiss
    @State var signUp = SignUp()
    @State private var isValidEmail = false
    @State private var isValidPassword = false
    @State private var isValidCountry = false
    @State private var allFieldsValid: Bool = false
    
    @StateObject private var viewModel = SignUpViewModel()
    
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var navigateToHomePage = false
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("sign up to continue")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(
                    Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                )
                .padding(.leading, 20)
                .font(.title)
            
            EmailEntryView(email: $signUp.email, isValidEmail: $isValidEmail)
                .onChange(of: isValidEmail) { _, _ in allFieldsVaild() }
            
            PasswordEntryView(password: $signUp.password, isValidPassword: $isValidPassword, validationRequired: true)
                .onChange(of: isValidPassword) { _, _ in allFieldsVaild() }
            
            CountryView(country: $signUp.country, isValidCountry: $isValidCountry)
                .onChange(of: isValidCountry) { _, _ in allFieldsVaild() }
            
            Spacer()
            
            Button(action: {
                viewModel.signUpCompletion = { success, error in
                    if success {
                        sessionManager.login()
                        navigateToHomePage = true
                    } else {
                        showAlert = true
                        alertMessage = "Signup failed!\n\(error?.localizedDescription ?? "Unknown error")"
                    }
                }
                Task {
                    await viewModel.createUserAndLogin(User(name: signUp.name, email: signUp.email, password: signUp.password, country: signUp.country))
                }
            }) {
                HStack {
                    Text("Let's go")
                        .font(.headline)
                    
                    Image(systemName: "arrow.right")
                        .resizable()
                        .frame(width: 20, height: 15)
                }
                .padding()
                .cornerRadius(10)
            }
            .disabled(!allFieldsValid)
            .foregroundColor(
                allFieldsValid ? Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)) : Color(#colorLiteral(red: 0.6533104777, green: 0.6533104777, blue: 0.6533104777, alpha: 1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        allFieldsValid ? Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)) : Color(#colorLiteral(red: 0.6533104777, green: 0.6533104777, blue: 0.6533104777, alpha: 1)),
                        lineWidth: 0.5)
                    .frame(width: 0.5*UIScreen.main.bounds.width, height: 50)
            )
            .frame(width: 0.8*UIScreen.main.bounds.width, height: 50)
            .font(.title3)
            .padding(.top, 20)
            .padding(.bottom, 50)
            
            if viewModel.processing {
                ProgressView()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Sign Up"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .onChange(of: navigateToHomePage, { oldValue, newValue in
            guard newValue else { return }
            dismiss()
        })
        .navigationDestination(isPresented: $navigateToHomePage) {
            HomeView()
        }
        .frame(maxHeight: .infinity)
        .navigationTitle("Welcome")
        .background(
            linearGradient.ignoresSafeArea()
        )
    }
    
    private func allFieldsVaild() {
        allFieldsValid = isValidEmail && isValidPassword && isValidCountry
    }
}
