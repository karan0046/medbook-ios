//
//  BookSortView.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

import SwiftUI

struct BookSortView: View {
    @StateObject var viewModel = BookSortViewModel()
    @Binding var selectedSortByOption: String
    
    var body: some View {
        HStack(spacing: 16) {
            Text("Sort By:")
                .font(.headline)
                .foregroundColor(
                    Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
                )
                .bold()
                .frame(alignment: .leading)
            
            ForEach(viewModel.sortOptions, id: \.self) { option in
                Text(option)
                    .font(.headline)
                    .padding(.horizontal, 8)
                    .foregroundColor(
                        Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(selectedSortByOption == option ? Color(#colorLiteral(red: 0.6533104777, green: 0.6533104777, blue: 0.6533104777, alpha: 1)) : Color.clear)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(selectedSortByOption == option ? Color(#colorLiteral(red: 0.6533104777, green: 0.6533104777, blue: 0.6533104777, alpha: 1)) : Color.clear,
                                    lineWidth: selectedSortByOption == option ? 2 : 0)
                    )
                    .onTapGesture {
                        selectedSortByOption = option
                    }
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.leading, 10)
        .frame(maxWidth: .infinity)
        .onAppear {
            //selectedSortByOption = viewModel.sortOptions.first ?? selectedSortByOption
        }
    }
}
