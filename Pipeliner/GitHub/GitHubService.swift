//
//  GitHubService.swift
//  Pipeliner
//
//  Created by dx hero on 10/4/20.
//

import Foundation
import PromiseKit
import AwaitKit

class GitHubService: IService {
    
    internal let httpService: HttpService = HttpService()
    
    func getProjectName(baseUrl: String, projectId: String, token: String) throws -> String {
        let urlString: String = "\(baseUrl)"
        guard let url = URL(string: urlString) else {
            throw ApiError.invalidUrl
        }
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.setValue("bearer \(token)", forHTTPHeaderField:"Authorization")
        let data = try await(httpService.getData(request: request))
        let project = try JSONDecoder().decode(Project.self, from: data)
        return project.name
    }
    
    func getPipelines(config: Config, pipelineCount: Int) throws -> [Pipeline] {
        let urlString: String = "\(config.baseUrl)/actions/runs?per_page=\(pipelineCount)"
        guard let url = URL(string: urlString) else {
            throw ApiError.invalidUrl
        }
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.setValue("bearer \(config.token)", forHTTPHeaderField:"Authorization")
        let data = try await(httpService.getData(request: request))
        let workflows = try JSONDecoder().decode(Workflows.self, from: data)
        
        var pipelines = [Pipeline]()
        
        workflows.workflow_runs.forEach {
            pipelines.append(Pipeline(
                                id: $0.id,
                                sha: $0.head_sha,
                                ref: $0.repository.html_url,
                                status: $0.status,
                                created_at: $0.created_at,
                                updated_at: $0.updated_at,
                                web_url: $0.html_url))
        }
        
        return pipelines
    }
}
