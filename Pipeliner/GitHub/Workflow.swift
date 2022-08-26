//
//  Workflow.swift
//  Pipeliner
//
//  Created by dx hero on 10/10/20.
//

import Foundation

struct GithubWorkflows: Decodable {
    let workflow_runs: [Workflow]
}

struct Workflow: Decodable, Identifiable {
    enum Status: Decodable {
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

       case completed(conclusion: Conclusion)
        case inProgress
        case queued
        case success
    }

    let id: Int
    let sha: String
    let status: Status
    let createdAt: String
    let updatedAt: String
    let url: String
    let ref: String

    private enum CodingKeys: String, CodingKey {
        case conclusion
        case id
        case gitlabSha = "sha"
        case githubSha = "head_sha"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case gitlabUrl = "web_url"
        case githubUrl = "url"
        case gitlabRef = "ref"
        case githubRef = "head_branch"
        case status
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        if let gitlabSha = try? container.decode(String.self, forKey: .gitlabSha) {
            self.sha = gitlabSha
        } else {
            self.sha = try container.decode(String.self, forKey: .githubSha)
        }
        let status = try container.decode(String.self, forKey: .status)
        switch status {
        case "completed":
            let conclusion = try container.decode(Status.Conclusion.self, forKey: .conclusion)
            self.status = .completed(conclusion: conclusion)
        case "in_progress":
            self.status = .inProgress
        case "queued":
            self.status = .queued
        case "success":
            self.status = .success
        default:
            let errorDescription = "[\(status)] is not recognized as status value"
            throw DecodingError.typeMismatch(
                Status.self, .init(codingPath: decoder.codingPath, debugDescription: errorDescription))
        }

        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.updatedAt = try container.decode(String.self, forKey: .updatedAt)
        if let url = try? container.decode(String.self, forKey: .gitlabUrl) {
            self.url = url
        } else {
            self.url = try container.decode(String.self, forKey: .githubUrl)
        }
        if let ref = try? container.decode(String.self, forKey: .gitlabRef) {
            self.ref = ref
        } else {
            self.ref = try container.decode(String.self, forKey: .githubRef)
        }
    }
}

extension Pipeline {
    init(_ workflow: Workflow) {
        self.id = workflow.id
        self.sha = workflow.sha
        self.ref = workflow.ref
        self.status = workflow.status.toPipelineStatus()
        self.created_at = workflow.createdAt
        self.updated_at = workflow.updatedAt
        self.web_url = workflow.url
    }
}

private extension Workflow.Status {
    func toPipelineStatus() -> PipelineStatus {

        if case .completed(let conclusion) = self, conclusion == .success {
            return .SUCCESS
        } else if case .success = self {
            return .SUCCESS
        }
        return .FAILED
    }
}
