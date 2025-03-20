//
//  BookSortViewModel.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

import SwiftUI

class BookSortViewModel: ObservableObject {
    var sortOptions: [String] = SortBy.allCases.map({$0.rawValue})
    
    init() {
        
    }
    
    deinit {
        print("BookSortViewModel deallocated")
    }
}
