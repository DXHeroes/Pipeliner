//
//  ApiError.swift
//  Pipeliner
//
//  Created by dx hero on 03.09.2020.
//

import Foundation
enum ApiError: Error {
    case invalidUrl
    case emptyResponse
    case invalidDate
    case configurationNotFound
}
