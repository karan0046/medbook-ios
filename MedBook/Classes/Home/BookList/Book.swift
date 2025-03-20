//
//  Book.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

import Foundation

struct Book: Identifiable, Equatable, Hashable {
    var id: String
    let title: String
    let authorName: [String]
    let editionCount: Int
    let coverI: Int
    let firstPublishYear: Int
    var isBookmarked: Bool = false

    init(json: [String: Any]) {
        self.id = json["key"] as? String ?? json["id"] as? String ?? UUID().uuidString
        self.title = json["title"] as? String ?? "Unknown Title"
        self.authorName = json["author_name"] as? [String] ?? json["authorName"] as? [String] ?? []
        self.editionCount = json["edition_count"] as? Int ?? json["editionCount"] as? Int ?? 0
        self.coverI = json["cover_i"] as? Int ?? json["coverI"] as? Int ?? 0
        self.firstPublishYear = json["first_publish_year"] as? Int ?? json["firstPublishYear"] as? Int ?? 0
    }

    func toDic() -> [String: Any] {
        [
            "id": id,
            "title": title,
            "author_name": authorName,
            "edition_count": editionCount,
            "cover_i": coverI,
            "first_publish_year": firstPublishYear
        ]
    }
}
