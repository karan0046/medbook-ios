//
//  BookListView.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

import SwiftUI

struct BookListView: View {
    @StateObject var viewModel = BookListViewModel()
    @State var selecedYear: String = ""
    @Binding var searchText: String
    @Binding var selectedSortByOption: String
    @State private var searchBookList: DispatchWorkItem?
    
    var body: some View {
        VStack {
            BookListTableView(bookList: $viewModel.bookList, onLastBookAppearAction: { book in
                Task {
                    selectedSortByOption = ""
                    await viewModel.fetchData(searchText: searchText, sortByOption: selectedSortByOption, clearList: false)
                }
            }, onBookSwipeAction: { book in
                Task {
                    await viewModel.updateBookmark(book)
                }
            })
            .scrollContentBackground(.hidden)
            .onChange(of: searchText) { oldValue, newValue in
                guard searchText.count > 2 else {
                    selectedSortByOption = ""
                    viewModel.clearBookList()
                    return
                }
                // do not perform search immediately when searchText is changed
                searchBookList?.cancel()
                searchBookList?.cancel()
                let task = DispatchWorkItem {
                    Task {
                        selectedSortByOption = ""
                        await viewModel.fetchData(searchText: searchText, sortByOption: selectedSortByOption)
                    }
                }
                searchBookList = task
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: task)
            }
            .onChange(of: selectedSortByOption) { oldValue, newValue in
                viewModel.sortBookList(selectedSortByOption)
            }
            .onAppear {
                Task {
                    await viewModel.loadBookmarks()
                }
            }
            
            if viewModel.loading {
                HStack {
                    Spacer()
                    ProgressView("Loading...")
                    Spacer()
                }
                Spacer()
            }
        }
    }
}
