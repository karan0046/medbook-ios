//
//  APIResponseStatus.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 20/03/25.
//

enum APIResponseStatus: Error {
    case unknown
    case success
    case notReachable
    case unauthorized
    case serverError
    case unexpectedResponse
    case notFound
    case notModified
    case cancelled
    case invalidRequest
    case notSupported
}
