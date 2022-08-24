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

enum APIError: Error {
    case wrongURL
    case genericError
    case decodingError
    case missingToken
}

final class APIClient {

    private let session: URLSession = URLSession.shared
    private let decoder: JSONDecoder = JSONDecoder()

    private func generateRequest(
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
            throw(APIError.genericError)
        }
        NetworkingLogger.logResponse(
            (response as? HTTPURLResponse),
            data: data,
            error: nil
        )
        let successRange = 200..<300
        guard successRange.contains((response as? HTTPURLResponse)?.statusCode ?? 0) else {
            throw(APIError.genericError)
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            NetworkingLogger.log(error)
            throw(APIError.decodingError)
        }
    }
}
