//
//  API.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 20/03/25.
//

import Foundation

class API: APIProtocol {
    var url: URL
    var method: HTTPMethod = .get
    var bodyParams: [String: Any]?
    var headers: [String: String] = [:]

    init(_ url: URL) {
        self.url = url
    }
    
    func method(_ method: HTTPMethod) -> Self {
        self.method = method
        return self
    }

    func queryItems(_ queryItems: [String: String]) -> Self {
        var urlQueryItems = [URLQueryItem]()
        queryItems.forEach { (key, value) in
            urlQueryItems.append(URLQueryItem(name: key, value: value))
        }
        self.url = self.url.appending(queryItems: urlQueryItems)
        return self
    }

    func bodyParams(_ bodyParams: [String: Any]?) -> Self {
        self.bodyParams = bodyParams
        return self
    }

    func headers(_ headers: [String: String]) -> Self {
        self.headers = headers
        return self
    }

    func execute() async -> (APIResponseStatus, HTTPURLResponse?, Any?, String?) {
        return await APIService.shared.executeAPI(self)
    }
}
