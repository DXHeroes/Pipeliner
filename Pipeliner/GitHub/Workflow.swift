//
//  Workflow.swift
//  Pipeliner
//
//  Created by dx hero on 10/10/20.
//

import Foundation

//struct Workflows: Decodable {
//    let workflowRuns: [Workflow]
//}

struct Workflow: Decodable, Identifiable {

    enum Status: String, Decodable {
//        enum Conclusion: String, Decodable {
//            case actionRequired
//            case cancelled
//            case failure
//            case neutral
//            case skipped
//            case stale
//            case success
//            case timedOut
//        }
//
//        case completed(Conclusion)
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
        //case conclusion
        case id
        case sha
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        //case headBranch
        case url = "web_url"
        case ref
        //case repository
        case status
    }
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.createdAt = try container.decode(String.self, forKey: .createdAt)
//        self.id = try container.decode(Int.self, forKey: .id)
//        self.sha = try container.decode(String.self, forKey: .headSha)
//        self.updatedAt = try container.decode(String.self, forKey: .updatedAt)
//        self.url = try container.decode(String.self, forKey: .htmlUrl)
//        self.ref = try container.decode(String.self, forKey: .headBranch)
//
//
//        let status = try container.decode(String.self, forKey: .status)
//        switch status {
//        case "completed":
//            let conclusion = try container.decode(Status.Conclusion.self, forKey: .conclusion)
//            self.status = .completed(conclusion)
//        case "in_progress":
//            self.status = .inProgress
//        case "queued":
//            self.status = .queued
//        default:
//            let errorDescription = "[\(status)] is not recognized as status value"
//            throw DecodingError.typeMismatch(
//                Status.self, .init(codingPath: decoder.codingPath, debugDescription: errorDescription))
//        }
//    }
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
        if case .success = self {
            //case .completed(let conclusion) = self,
            return .SUCCESS
        }
        
        return .FAILED
    }
}
