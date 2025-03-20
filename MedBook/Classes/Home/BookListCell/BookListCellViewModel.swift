//
//  BookListCellViewModel.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

import SwiftUI

@MainActor
class BookListCellViewModel: ObservableObject {
    
    @Published var processing: Bool = false
    @Published var bookmarked: Bool = false
    
    init() {
        
    }
    
    func fetchBookmarkState(_ book: Book) async {
        let exits = await Table.BookMark.exists(withId: book.id)
        bookmarked = exits
    }
    
    func getImageURL(_ book: Book) -> String {
        let imageSourceURL = "https://covers.openlibrary.org/b/id/\(book.coverI)-M.jpg"
        return imageSourceURL
    }
    
    deinit {
        print("BookListCellViewModel deallocated")
    }
}
