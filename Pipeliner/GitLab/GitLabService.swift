//
//  GitLabService.swift
//  Pipeliner
//
//  Created by dx hero on 03.09.2020.
//

import Foundation
import PromiseKit
import AwaitKit

struct Project: Codable{
    let name: String
}
class GitLabService: IService {
    internal let httpService: HttpService = HttpService()
    
    func getProjectName(baseUrl: String, projectId: String, token: String) throws -> String {
        let urlString: String = "\(baseUrl)/api/v4/projects/\(projectId)"
        guard let url = URL(string: urlString) else {
            throw ApiError.invalidUrl
        }
        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField:"PRIVATE-TOKEN")
        let data = try `await`(httpService.getData(request: request))
        let project = try JSONDecoder().decode(Project.self, from: data)
        return project.name
    }
    
    func getPipelines(config: Config, pipelineCount: Int) throws -> [Pipeline] {
        let urlString: String = "\(config.baseUrl)/api/v4/projects/\(config.projectId)/pipelines?per_page=\(pipelineCount)"
        guard let url = URL(string: urlString) else {
            throw ApiError.invalidUrl
        }
        var request = URLRequest(url: url)
        request.setValue(config.token, forHTTPHeaderField:"PRIVATE-TOKEN")
        do {
            let data = try `await`(httpService.getData(request: request))
            let pipelines = try JSONDecoder().decode([Pipeline].self, from: data)
            return pipelines
        }
        catch {
            print("GitLabService Error", error)
            return []
        }
    }}
