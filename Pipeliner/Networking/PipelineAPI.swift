//
//  PipelineAPI.swift
//  Pipeliner
//
//  Created by Michal Sverak on 24.08.2022.
//

import Foundation

protocol PipelineAPI {

    func getProjectName(
        for service: ServiceType,
        baseUrl: String,
        projectId: String,
        token: String
    ) async throws -> Project

    func getPipelines(
        config: Config,
        pipelineCount: Int
    ) async throws -> [Pipeline]
}

extension APIClient: PipelineAPI {

    func getProjectName(
        for service: ServiceType,
        baseUrl: String,
        projectId: String,
        token: String
    ) async throws -> Project {
        let urlString: String
        let headers: [String: String]
        switch service {
        case .gitlab:
            urlString = "\(baseUrl)/api/v4/projects/\(projectId)"
            headers = ["PRIVATE-TOKEN" : token]
        case .github:
            urlString = "\(baseUrl)"
            headers = [
                "Accept": "application/vnd.github.v3+json",
                "Authorization": "bearer \(token)"
            ]
        }
        guard let url = URL(string: urlString) else {
            throw ApiError.invalidUrl
        }
        let request = generateRequest(
            for: url,
            with: headers,
            method: .get,
            body: nil
        )
        guard let project: Project = try? await self.getData(for: request) else {
            throw(ApiError.genericError)
        }
        return project
    }

    func getPipelines(
        config: Config,
        pipelineCount: Int
    ) async throws -> [Pipeline] {
        let headers: [String: String]
        let urlString: String
        switch config.serviceType {
        case .gitlab:
            urlString = "\(config.baseUrl)/api/v4/projects/\(config.projectId)/pipelines?per_page=\(pipelineCount)"
            headers = ["PRIVATE-TOKEN" : config.token]
        case .github:
            urlString = "\(config.baseUrl)/actions/runs?per_page=\(pipelineCount)"
            headers = [
                "Accept": "application/vnd.github.v3+json",
                "Authorization": "bearer \(config.token)"
            ]
        }
        guard let url = URL(string: urlString) else {
            throw ApiError.invalidUrl
        }
        let request = generateRequest(
            for: url,
            with: headers,
            method: .get,
            body: nil
        )
        guard let workflows: Workflows = try? await self.getData(for: request) else {
            throw(ApiError.genericError)
        }
        return workflows.workflowRuns.map(Pipeline.init)
    }
}
