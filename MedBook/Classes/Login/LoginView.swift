//
//  LoginView.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @Environment(\.dismiss) private var dismiss
    @State var login = Login()
    @State private var isValidEmail = false
    @State private var isValidPassword = false
    @State private var allFieldsValid: Bool = false
    
    @StateObject var viewModel = LoginViewModel()
    
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var navigateToHomePage = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Text("log in to continue")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(
                        Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                    )
                    .padding(.leading, 20)
                    .font(.title)
                
                VStack(spacing: 20) {
                    EmailEntryView(email: $login.email, isValidEmail: $isValidEmail)
                        .onChange(of: isValidEmail) { _, _ in allFieldsVaild() }
                    PasswordEntryView(password: $login.password, isValidPassword: $isValidPassword, validationRequired: false)
                        .onChange(of: login.password) { _, _ in allFieldsVaild() }
                }
                
                Spacer()
                
                Button(action:{
                    Task {
                        await viewModel.checkValidCreds(login)
                        if viewModel.validCreds {
                            sessionManager.login()
                            dismiss()
                            navigateToHomePage = true
                        } else {
                            showAlert = true
                            alertMessage = "Credentials are not Valid \n Please enter correct details"
                        }
                    }
                })
                {
                    HStack {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(
                                allFieldsValid ? Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)) : Color(#colorLiteral(red: 0.6533104777, green: 0.6533104777, blue: 0.6533104777, alpha: 1))
                            )
                        
                        Image(systemName: "arrow.right")
                            .resizable()
                            .frame(width: 20, height: 15)
                            .foregroundColor(
                                allFieldsValid ? Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)) : Color(#colorLiteral(red: 0.6533104777, green: 0.6533104777, blue: 0.6533104777, alpha: 1))
                            )
                    }
                    .padding()
                    .cornerRadius(10)
                }
                .disabled(!allFieldsValid)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            allFieldsValid ? Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)) : Color(#colorLiteral(red: 0.6533104777, green: 0.6533104777, blue: 0.6533104777, alpha: 1)),
                            lineWidth: 0.5
                        )
                        .frame(width: 0.5*UIScreen.main.bounds.width, height: 50)
                )
                .frame(width: 0.5*UIScreen.main.bounds.width, height: 50)
                .font(.title3)
                .padding(.top, 30)
                .padding(.bottom, 50)
                
                if viewModel.processing {
                    ProgressView()
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Login"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .navigationDestination(isPresented: $navigateToHomePage) {
                HomeView()
            }
            .navigationTitle("Welcome")
            .background(
                linearGradient.ignoresSafeArea()
            )
        }
    }
    
    private func allFieldsVaild()  {
        allFieldsValid = isValidEmail && !login.password.isEmpty
    }
}
