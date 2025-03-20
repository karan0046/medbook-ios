//
//  LaunchScreenView.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

import SwiftUI

struct LaunchScreenView: View {
    @StateObject var viewModel = LaunchScreenViewModel()
    @State private var scaleEffect = 0.5
    @Environment(\.dismiss) var dismiss
    @State private var navigateToHome = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                VStack {
                    Image(systemName: "books.vertical")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .foregroundColor(
                            Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
                        )
                        .scaleEffect(scaleEffect)
                        .onAppear {
                            withAnimation(.easeOut(duration: 1.5)) {
                                scaleEffect = 1.0
                            }
                            if viewModel.userLoggedIn {
                                navigateToHome = true
                            }
                        }
                }
                .padding(.bottom, 40)
                
                Spacer()
                
                if !viewModel.userLoggedIn {
                    HStack {
                        NavigationLink(destination: SignUpView(), label: {
                            Text("Signup")
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                                .foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                                .cornerRadius(10)
                                .font(.headline)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                        })
                        .frame(width: 0.4*UIScreen.main.bounds.width, height: 50)
                        
                        
                        NavigationLink(destination: LoginView(), label: {
                            Text("Login")
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                                .foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                                .cornerRadius(10)
                                .font(.headline)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                        })
                        .frame(width: 0.4*UIScreen.main.bounds.width, height: 50)
                    }
                    .padding(.bottom, 50)
                }
            }
            .onChange(of: viewModel.userLoggedIn, { oldValue, newValue in
                navigateToHome = newValue
            })
            .navigationDestination(isPresented: $navigateToHome) {
                HomeView()
            }
            .navigationTitle("MedBook")
            .navigationBarBackButtonHidden()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                linearGradient
                    .ignoresSafeArea()
            )
        }
    }
}

let linearGradient = LinearGradient(
    gradient: Gradient(colors: [
        Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)).opacity(0.8),
        Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)).opacity(0.4),
        Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)).opacity(0.2),
        Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)).opacity(0.1),
        Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)).opacity(0.0)
    ]),
    startPoint: .top,
    endPoint: .bottom
)
