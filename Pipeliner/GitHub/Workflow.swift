//
//  Workflow.swift
//  Pipeliner
//
//  Created by dx hero on 10/10/20.
//

import Foundation

struct Workflows: Decodable {
    let workflowRuns: [Workflow]
}

struct Workflow: Decodable, Identifiable {
    enum Status {
        enum Conclusion: String, Decodable {
            case actionRequired
            case cancelled
            case failure
            case neutral
            case skipped
            case stale
            case success
            case timedOut
        }

        case completed(Conclusion)
        case inProgress
        case queued
    }

    private enum CodingKeys: CodingKey {
        case conclusion
        case createdAt
        case headSha
        case htmlUrl
        case id
        case repository
        case status
        case updatedAt
    }

    public let id: Int
    let sha: String
    let status: Status
    let createdAt: String
    let updatedAt: String
    let url: String
    let repository: Repository

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.id = try container.decode(Int.self, forKey: .id)
        self.repository = try container.decode(Repository.self, forKey: .repository)
        self.sha = try container.decode(String.self, forKey: .headSha)
        self.updatedAt = try container.decode(String.self, forKey: .updatedAt)
        self.url = try container.decode(String.self, forKey: .htmlUrl)

        let status = try container.decode(String.self, forKey: .status)
        switch status {
        case "completed":
            let conclusion = try container.decode(Status.Conclusion.self, forKey: .conclusion)
            self.status = .completed(conclusion)
        case "in_progress":
            self.status = .inProgress
        case "queued":
            self.status = .queued
        default:
            let errorDescription = "[\(status)] is not recognized as status value"
            throw DecodingError.typeMismatch(
                Status.self, .init(codingPath: decoder.codingPath, debugDescription: errorDescription))
        }
    }
}

extension Pipeline {
    init(_ workflow: Workflow) {
        self.id = workflow.id
        self.sha = workflow.sha
        self.ref = workflow.repository.htmlUrl
        self.status = workflow.status.toPipelineStatus()
        self.created_at = workflow.createdAt
        self.updated_at = workflow.updatedAt
        self.web_url = workflow.url
    }
}

private extension Workflow.Status {
    func toPipelineStatus() -> PipelineStatus {
        if case .completed(let conclusion) = self, case .success = conclusion {
            return .SUCCESS
        }

        return .FAILED
    }
}

struct Repository: Codable {
    let htmlUrl: String
}
