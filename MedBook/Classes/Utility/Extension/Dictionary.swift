//
//  Dictionary.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

import Foundation

extension Dictionary {
    func jsonString() -> String? {
        var options: JSONSerialization.WritingOptions = [.prettyPrinted]
        options = [.prettyPrinted, .sortedKeys]
        if let jd = try? JSONSerialization.data(withJSONObject: self, options: options), let str = String(data: jd, encoding: .utf8) {
            return str
        }
        return nil
    }
}
