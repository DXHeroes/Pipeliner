//
//  Workflow.swift
//  Pipeliner
//
//  Created by dx hero on 10/10/20.
//

import Foundation

struct Workflows: Decodable {
    var total_count: Int
    var workflow_runs: [Workflow]
}

struct Workflow: Codable, Identifiable {
    public let id: Int
    let head_sha: String
    let status: String
    let created_at: String
    let updated_at: String
    let html_url: String
    let repository: Repository
}

struct Repository: Codable {
    let html_url: String
}
