//
//  BookListCellView.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

import SwiftUI

struct BookListCellView: View {
    @StateObject var viewModel = BookListCellViewModel()
    
    var book: Book
    init(book: Book) {
        self.book = book
    }
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: viewModel.getImageURL(book))) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 80, height: 120)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 120)
                        .cornerRadius(10)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 80, height: 120)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text(book.title)
                    .font(.headline)
                    .foregroundColor(
                        Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                    )
                
                HStack(spacing: 2) {
                    Image(systemName: "star")
                        .foregroundColor(.orange)
                    Text("\(book.editionCount)")
                        .foregroundColor(.orange)
                }
                
                Text("Published in \(String(book.firstPublishYear))")
                    .font(.footnote)
                    .foregroundColor(.gray)
                
                Text("Author(s): \(book.authorName.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.joined(separator: ", "))")
                    .font(.footnote)
                    .foregroundColor(.gray)
                
                Spacer()
            }
            Spacer()
            
            Image(systemName: book.isBookmarked ? "bookmark.fill" : "bookmark")
                .foregroundColor(book.isBookmarked ? Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)) : .gray)
                .imageScale(.large)
        }
        .padding()
    }
}
