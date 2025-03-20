//
//  HomeView.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//


import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    @State private var showSidebar = false
    @State private var selectedTab = 0
    @State var selectedSortByOption: String = ""
    @StateObject var viewModel = HomeViewModel()
    @State private var navigateTolaunchScreen = false
    
    var body: some View {
        VStack(spacing: 20) {
            HomeSearchView(searchText: $searchText)
            if searchText.count > 2 {
                BookSortView(selectedSortByOption: $selectedSortByOption)
                BookListView(searchText: $searchText, selectedSortByOption: $selectedSortByOption)
            }
            Spacer()
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden()
        .toolbar {
            
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Image(systemName: "book.fill")
                        .foregroundColor(
                            Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                        )
                    Text("MedBook")
                        .font(.title)
                        .foregroundColor(
                            Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                        )
                        .bold()
                }.padding(.top, 20)
            }
            
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {

                NavigationLink(destination: BookMarkListView()) {
                    Image(systemName: "bookmark.fill")
                        .foregroundColor(.black)
                }.padding(.top, 20)
                
                Button(action: {
                    Task {
                        await viewModel.logOut()
                    }
                }) {
                    Image(systemName: "rectangle.portrait.and.arrow.forward")
                        .foregroundColor(.red)
                }.padding(.top, 20)
            }
            
            
        }
        .onChange(of: viewModel.logoutSuccess) { oldValue, newValue in
            guard newValue else { return }
            navigateTolaunchScreen = true
        }
        .navigationDestination(isPresented: $navigateTolaunchScreen) {
            LaunchScreenView()
        }
        .navigationBarBackButtonHidden()
        .background(
            linearGradient.ignoresSafeArea()
        )
    }
}
