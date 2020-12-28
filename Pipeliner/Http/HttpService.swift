//
//  HttpService.swift
//  Pipeliner
//
//  Created by dx hero on 03.09.2020.
//

import Foundation
import PromiseKit
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
class HttpService {
    
    func getData(request: URLRequest) -> Promise<Data> {
        return Promise { promise in
            URLSession.shared.dataTask(with: request) { (data: Data?, res: URLResponse?, error: Error?) in
                guard let statusCode = (res as? HTTPURLResponse)?.statusCode else {
                    promise.reject(HTTPError.noInternetConnection)
                    return
                }
                guard (200...299).contains(statusCode) else {
                    promise.reject(HTTPError.serverSideError(statusCode: statusCode, url: request.url!.description))
                    return
                }
                if let error = error {
                    promise.reject(error)
                }
                if let data = data {
                    promise.fulfill(data)
                }
            }.resume()
        }
    }
}
