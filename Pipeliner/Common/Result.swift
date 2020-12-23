//
//  Result.swift
//  Pipeliner
//
//  Created by dx hero on 11/1/20.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}
