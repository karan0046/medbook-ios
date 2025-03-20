//
//  RequirementRow.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 20/03/25.
//

import SwiftUI

struct RequirementRow: View {
    let label: String
    let isMet: Bool

    var body: some View {
        HStack() {
            Image(systemName: isMet ? "checkmark.square" : "square")
                .foregroundColor(isMet ? .green : Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
            Text(label)
                .foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
        }
    }
}
