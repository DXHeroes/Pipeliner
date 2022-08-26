//
//  PipelineAPI.swift
//  Pipeliner
//
//  Created by Michal Sverak on 24.08.2022.
//

import Foundation

protocol PipelineAPI {

    func getProjectName(
        baseUrl: String,
        headers: [String: String],
        projectId: String,
        token: String
    ) async throws -> Project

    func getPipelines(
        config: Config,
        headers: [String: String],
        pipelineCount: Int
    ) async throws -> [Pipeline]
}

extension APIClient: PipelineAPI {

    func getProjectName(
        baseUrl: String,
        headers: [String: String],
        projectId: String,
        token: String
    ) async throws -> Project {
        //github
        //let urlString: String = "\(baseUrl)"

        //gitlab
        let urlString: String = "\(baseUrl)/api/v4/projects/\(projectId)"
        guard let url = URL(string: urlString) else {
            throw ApiError.invalidUrl
        }
//        let header = [
//            "Accept": "application/vnd.github.v3+json",
//            "Authorization": "bearer \(token)"
//        ]
        let request = generateRequest(
            for: url,
            with: headers,
            method: .post,
            body: nil
        )
        guard let project: Project = try? await self.getData(for: request) else {
            throw(ApiError.genericError)
        }
        return project
    }

    func getPipelines(
        config: Config,
        headers: [String: String],
        pipelineCount: Int
    ) async throws -> [Pipeline] {

        let urlString: String = "\(config.baseUrl)/actions/runs?per_page=\(pipelineCount)"
        guard let url = URL(string: urlString) else {
            throw ApiError.invalidUrl
        }
//        let header = [
//            "Accept": "application/vnd.github.v3+json",
//            "Authorization": "bearer \(config.token)"
//        ]
        let request = generateRequest(
            for: url,
            with: headers,
            method: .post,
            body: nil
        )
        guard let workflows: Workflows = try? await self.getData(for: request) else {
            throw(ApiError.genericError)
        }
        return workflows.workflowRuns.map(Pipeline.init)
    }
}
