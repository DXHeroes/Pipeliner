//
//  ApiClient.swift
//  Pipeliner
//
//  Created by Michal Sverak on 24.08.2022.
//

import Foundation
import os.log

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum HTTPError: LocalizedError {
    case serverSideError(statusCode: Int, url: String)
    case noInternetConnection
}

extension HTTPError {
    public var localizedDescription: String {
        switch self {
        case .serverSideError(statusCode: let statusCode, url: let url):
            return NSLocalizedString("Request to \(url) returned response with \(statusCode) status code" , comment: "Check input values")
        case .noInternetConnection:
            return NSLocalizedString("Are you connected?" , comment: "Check internet connection")
        }
    }
}

enum ApiError: String, Error {
    case genericError = "Something went wrong"
    case invalidUrl = "Invalid URL"
    case invalidDate = "Invalid date"
    case configurationNotFound = "Configuration not found"
    case decodingError = "Wrong data"
}

final class APIClient {

    private let session: URLSession = URLSession.shared
    private let decoder: JSONDecoder = JSONDecoder()

    func generateRequest(
        for url: URL,
        with header: [String:String],
        method: HTTPMethod,
        body: Data? = nil
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        for field in header {
            request.setValue(field.value, forHTTPHeaderField: field.key)
        }
        request.httpBody = body
        return request
    }

    func getData<T: Decodable>(
        _ : T.Type = T.self,
        for request: URLRequest
    ) async throws -> T {
        NetworkingLogger.logRequest(request, config: session.configuration)
        guard let (data, response) = try? await session.data(for: request) else {
            throw(ApiError.genericError)
        }
        NetworkingLogger.logResponse(
            (response as? HTTPURLResponse),
            data: data,
            error: nil
        )
        let successRange = 200..<300
        guard successRange.contains((response as? HTTPURLResponse)?.statusCode ?? 0) else {
            throw(ApiError.genericError)
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            NetworkingLogger.log(error)
            throw(ApiError.decodingError)
        }
    }
}
