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
        
        guard let data = try? await(httpService.getData(request: request)) else {
            throw ApiError.emptyResponse
        }
        
        guard let project = try? JSONDecoder().decode(Project.self, from: data) else {
            throw ApiError.decodeError
        }
        
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
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let workflows = try decoder.decode(Workflows.self, from: data)
        return workflows.workflowRuns.map(Pipeline.init)
    }
}
