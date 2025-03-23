//
//  BookMarkListView.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

import SwiftUI

struct BookMarkListView: View {
    @StateObject var viewModel = BookMarkListViewModel()
    
    var body: some View {
        VStack {
            Text("Bookmarks")
                .font(.title)
                .bold()
                .padding(EdgeInsets(top: 0, leading: 12, bottom: 10, trailing: 10))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            BookListTableView(bookList: $viewModel.bookMarkList, onLastBookAppearAction: { book in
                // no Action needed
            }, onBookSwipeAction: { book in
                Task {
                    await viewModel.removeBookMark(book)
                    await MainActor.run {
                        withAnimation(.bouncy(duration: 3.0)) {
                            viewModel.refreshBookFromList(book)
                        }
                    }
                }
            })
            .padding(.top, -20)
            .onAppear{
                Task {
                    await viewModel.fetchData()
                }
            }
            .scrollContentBackground(.hidden)
        }
        .background(linearGradient.ignoresSafeArea())
    }
}
