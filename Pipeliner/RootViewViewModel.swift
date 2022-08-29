//
//  MainViewViewModel.swift
//  Pipeliner
//
//  Created by Michal Sverak on 26.08.2022.
//

import Foundation

final class RootViewViewModel: ObservableObject {

    private let pipelinerService: PipelinerService = PipelinerService()
    @Published var pipelines: [PipelineResult] = []
    @Published var configurations: [Config] = []

    init() {
        //TODO: this needs error handling
        initialDataLoad()
    }

    func initialDataLoad() {
        Task {
            let pipelines = try await self.pipelinerService.getPipelines(pipelineCount: 10)
            let configurations = ConfigurationService.getConfigurations()
            self.save(configurations: configurations, pipelines: pipelines)
        }
    }

    func loadData(
        _ serviceType: ServiceType,
        baseUrl: String,
        projectId: String,
        token: String
    ) async throws {
        let config = try await pipelinerService.getConfig(
            serviceType,
            baseUrl: baseUrl,
            projectId: projectId,
            token: token
        )
        let configurations = ConfigurationService.addConfiguration(config: config)
        let pipelines = try await pipelinerService.getPipelines(pipelineCount: 10)
        self.save(configurations: configurations, pipelines: pipelines)
    }

    private func save(configurations: [Config], pipelines: [PipelineResult]) {
        DispatchQueue.main.async {
            self.configurations = configurations
            self.pipelines = pipelines
        }
    }

    func reloadPipelines() async throws {
        self.pipelines = try await self.pipelinerService.getPipelines(pipelineCount: 10)
    }
}
