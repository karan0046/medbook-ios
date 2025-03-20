//
//  APIService.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

import Foundation

class APIService {
    static let shared = APIService()
    private let timeoutInterval: TimeInterval = 60
    
    private init() { }
    
    func executeAPI(_ api: APIProtocol) async -> ((APIResponseStatus, HTTPURLResponse?, Any?, String?)) {
        guard let request = await buildRequest(forAPI: api) else {
            return (.invalidRequest, nil, nil, nil)
        }
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                return (.unexpectedResponse, nil, nil, nil)
            }
            switch httpResponse.statusCode {
            case 200...299:
                let jsonData = try JSONSerialization.jsonObject(with: data)
                return (.success, httpResponse, jsonData, nil)
            case 401:
                return (.unauthorized, httpResponse, nil, "Unauthorized access.")
            case 404:
                return (.notFound, httpResponse, nil, "Resource not found.")
            case 500...599:
                return (.serverError, httpResponse, nil, "Server encountered an error.")
            default:
                return (.unexpectedResponse, httpResponse, nil, "Unexpected response received.")
            }
        } catch is URLError {
            return (.notReachable, nil, nil, "Network not reachable.")
        } catch {
            return (.unknown, nil, nil, error.localizedDescription)
        }
    }
    
    private func buildRequest(forAPI api: APIProtocol) async -> URLRequest? {
        var request = URLRequest(url: api.url)
        request.httpMethod = api.method.rawValue
        request.timeoutInterval = timeoutInterval
        if let params = api.bodyParams,
           let body = try? JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted) {
            request.httpBody = body
        }
        let headers = await buildHeaders(forAPI: api)
        guard !headers.isEmpty else {
            return nil
        }
        request.allHTTPHeaderFields = headers
        return request
    }
    
    private func buildHeaders(forAPI api: APIProtocol) async -> [String: String] {
        var headers = [String: String]()
        headers["device-type"] = "ios"
        headers.merge(api.headers, uniquingKeysWith: {(_, new) in new})
        return headers
    }
}
