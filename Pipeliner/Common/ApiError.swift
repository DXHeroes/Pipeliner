//
//  ApiError.swift
//  Pipeliner
//
//  Created by dx hero on 03.09.2020.
//

import Foundation
enum ApiError: String, Error {
    case invalidUrl = "Invalid URL"
    case invalidDate = "Invalid date"
    case configurationNotFound = "Configuration not found"
}
