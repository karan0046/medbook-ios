//
//  BookListTableView.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 20/03/25.
//

import SwiftUI

struct BookListTableView: View {
    @Binding var bookList: [Book]
    var onLastBookAppearAction: (_ book: Book) -> Void
    var onBookSwipeAction: (_ book: Book) -> Void
    
    var body: some View {
        List {
            ForEach(Array(bookList), id: \.id) { book in
                BookListCellView(book: book)
                    .swipeActions(edge: .trailing) {
                        Button {
                            onBookSwipeAction(book)
                        } label: {
                            Label(!book.isBookmarked ? "Bookmark" : "Remove bookmark",
                                  systemImage: book.isBookmarked ? "bookmark.fill" : "bookmark")
                        }
                        .tint(!book.isBookmarked ? .green : .red)
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 10)
                            .padding(.bottom, 10)
                            .padding(.top, 10)
                            .foregroundColor(.white)
                    )
                    .onAppear {
                        if book == bookList.last {
                            onLastBookAppearAction(book)
                        }
                    }
            }
        }
    }
}
