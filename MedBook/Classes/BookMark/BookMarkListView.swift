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
            Text("BookMarks")
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
                }
            })
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
