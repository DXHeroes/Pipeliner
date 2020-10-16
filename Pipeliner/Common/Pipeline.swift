//
//  Response.swift
//  Pipeliner
//
//  Created by dx hero on 03.09.2020.
//

import Foundation
struct Pipeline: Codable, Identifiable {
    public let id: Int
    let sha: String
    let ref: String
    let status: String
    let created_at: String
    let updated_at: String
    let web_url: String
}
