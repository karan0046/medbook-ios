//
//  SelectionIdentifier.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

import CouchbaseLiteSwift

enum SelectionIdentifier {
    case all
    case select(columns: [String])
    case distinct(columns: [String])
    case custom(columns: [QueryFunction])
}
