//
//  Config.swift
//  Pipeliner
//
//  Created by dx hero on 16.09.2020.
//

import Foundation
struct Config: Codable, Identifiable, Hashable {
    let id: String
    let baseUrl: String
    let projectId: String
    let token: String
    let repositoryName: String
}
