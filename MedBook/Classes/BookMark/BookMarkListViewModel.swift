//
//  BookMarkListViewModel.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

import SwiftUI

@MainActor
class BookMarkListViewModel: ObservableObject {
    @Published var bookMarkList = [Book]()
    @Published var loading: Bool = false
    
    init() {
        
    }
    
    func fetchData() async {
        loading = true
        let records = await Table.BookMark.fetchAll(selectQuery: .distinct(columns: ["bookId"]), filters: [
            "user": FilterOperator.eq.value(CurrentUser.shared.profile?.email ?? "")
        ], sortBy: nil, offset: nil, limit: nil)
        var ids = [String]()
        records.forEach {record in
            guard let id = record["bookId"] as? String else { return }
            ids.append(id)
        }
        guard !records.isEmpty else {
            loading = false
            return
        }
        let booksRecords = await Table.Book.fetchAll(filters: [
            "id": FilterOperator.in_ls.value(ids)
        ], sortBy: nil, offset: nil, limit: nil)
        booksRecords.forEach { booksRecord in
            var book = Book(json: booksRecord)
            book.isBookmarked = true
            bookMarkList.append(book)
        }
        loading = false
    }
    
    func removeBookMark(_ book: Book) async {
        await Table.BookMark.deleteAll(filters: [
            "bookId": FilterOperator.eq.value(book.id),
            "user": FilterOperator.eq.value((CurrentUser.shared.profile?.email ?? ""))
        ]){ success, error in
            guard success else {
                print(error as Any)
                return
            }
        }
        
        if await Table.BookMark.fetchAll(filters: [
            "bookId": FilterOperator.eq.value(book.id)
        ], sortBy: nil, offset: nil, limit: nil).isEmpty {
            // If no records of this book is present in the BookMark Table then clear the book record.
            Task {
                await Table.Book.deleteAll(filters: ["id": FilterOperator.eq.value(book.id)]) { success, error in
                    guard success else {
                        print(error as Any)
                        return
                    }
                }
            }
        }
        if let index = bookMarkList.firstIndex(of: book) {
            bookMarkList.remove(at: index)
        }
    }
    
    deinit {
        print("BookMarkListViewModel deallocated")
    }
}
