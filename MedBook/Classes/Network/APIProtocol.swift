//
//  APIProtocol.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 20/03/25.
//

import Foundation

protocol APIProtocol {
    var url: URL { get }
    var method: HTTPMethod { get }
    var bodyParams: [String: Any]? { get }
    var headers: [String: String] { get }
}
