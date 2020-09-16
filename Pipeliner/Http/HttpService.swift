//
//  HttpService.swift
//  Pipeliner
//
//  Created by dx hero on 03.09.2020.
//

import Foundation
import PromiseKit
class HttpService {
    func getData(request: URLRequest) -> Promise<Data> {
        return Promise { promise in
            URLSession.shared.dataTask(with: request) { (data: Data?, res, error: Error?) in
                if let error = error {
                    promise.reject(error)
                }
                if let data = data {
                    promise.fulfill(data)
                }
        }.resume()}
    }
}
