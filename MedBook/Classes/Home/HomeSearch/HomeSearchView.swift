//
//  SearchView.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

import SwiftUI

struct HomeSearchView: View {
    @Binding var searchText: String
    
    var body: some View {
        VStack(spacing: 10) {
            
            Text("Which topic interests you today?")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(
                    Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                )
                .padding(.leading, 20)
                .font(.title2)
                .bold()
                .padding(.top, 20)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search", text: $searchText)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 8)
                }
            }
            .padding(.horizontal)
            .background(Color(.systemGray6))
            .cornerRadius(15)
            .padding(.leading, 15)
            .padding(.trailing, 15)
        }
    }
}
