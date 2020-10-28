//
//  Response.swift
//  Pipeliner
//
//  Created by dx hero on 03.09.2020.
//

import Foundation
struct Pipeline: Decodable, Identifiable {
    public let id: Int
    let sha: String
    let ref: String
    let status: PipelineStatus
    let created_at: String
    let updated_at: String
    let web_url: String
}
