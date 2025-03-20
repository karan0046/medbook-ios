//
//  BookListViewModel.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

import SwiftUI

@MainActor
class BookListViewModel: ObservableObject {
    @Published var loading: Bool = false
    @Published var bookList = [Book]()
    private var bookmarkedIDs: Set<String> = []
    
    private var limit: Int = 10
    private var offset: Int = 0
    
    let bookListURL: String = "https://openlibrary.org/search.json"
    
    init() {
        Task {
            await loadBookmarks()
        }
    }
    
    func clearBookList() {
        bookmarkedIDs.removeAll()
        bookList.removeAll()
    }
    
    func fetchData(searchText: String, sortByOption: String, clearList: Bool = true) async {
        guard !loading else { return }
        loading = true
        if clearList {
            clearBookList()
        }
        offset = bookList.count
        guard let url = URL(string: bookListURL) else {
            loading = false
            return
        }
        // call API to fetch data
        let api = API(url).queryItems([
            "title": searchText,
            "offset": "\(offset)",
            "limit": "\(limit)"
        ])
        let (responseStatus, _, result, _) = await api.execute()
        guard let data = result as? [String: Any],
              let docs = data["docs"] as? [[String: Any]] else {
            print(responseStatus)
            loading = false
            return
        }
        bookList.append(contentsOf: docs.map { Book(json: $0) })
        await loadBookmarks()
        loading = false
    }
    
    func loadBookmarks() async {
        let bookmarks = await Table.BookMark.fetchAll(filters: [
            "user": FilterOperator.eq.value((CurrentUser.shared.profile?.email ?? ""))
        ], sortBy: nil, offset: nil, limit: nil)
        bookmarkedIDs = Set(bookmarks.map { $0["bookId"] as? String ?? "" })
        for index in bookList.indices {
            bookList[index].isBookmarked = bookmarkedIDs.contains(bookList[index].id)
        }
    }
    
    func updateBookmark(_ book: Book) async {
        let isBookmarked = book.isBookmarked
        let filters = [
            "bookId": FilterOperator.eq.value(book.id),
            "user": FilterOperator.eq.value(CurrentUser.shared.profile?.email ?? "")
        ]
        
        if isBookmarked {
            await removeBookmark(for: book, filters: filters)
        } else {
            await addBookmark(for: book, filters: filters)
        }
        
        if let index = bookList.firstIndex(of: book) {
            bookList[index].isBookmarked.toggle()
        }
    }
    
    private func addBookmark(for book: Book, filters: [String: Any]) async {
        await Table.BookMark.insert(withJson: [
            "bookId": book.id,
            "user": (CurrentUser.shared.profile?.email ?? "")
        ], docId: UUID().uuidString) { success, error in
            guard success else {
                print(error as Any)
                return
            }
        }
        await Table.Book.upsert(id: book.id, withJson: book.toDic(), completion: { success, error in
            guard success else {
                print(error as Any)
                return
            }
        })
        if let index = bookList.firstIndex(of: book) {
            bookList[index].isBookmarked = true
        }
    }
    
    private func removeBookmark(for book: Book, filters: [String: Any]) async {
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
        if let index = bookList.firstIndex(of: book) {
            bookList[index].isBookmarked = false
        }
    }
    
    func sortBookList(_ sortBy: String) {
        switch SortBy(rawValue: sortBy) {
        case .title:
            bookList = bookList.sorted { book1, book2 in
                return book1.title < book2.title
            }
        case .year:
            bookList = bookList.sorted { book1, book2 in
                return book1.firstPublishYear > book2.firstPublishYear
            }
        case .hits:
            bookList = bookList.sorted { book1, book2 in
                return book1.editionCount > book2.editionCount
            }
        default:
            break
        }
    }
    
    deinit {
        print("BookListViewModel deallocated")
    }
}
