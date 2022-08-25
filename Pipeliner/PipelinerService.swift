//
//  PipelinerService.swift
//  Pipeliner
//
//  Created by dx hero on 03.09.2020.
//

import Foundation

class PipelinerService {

    internal let dateService: DateService
    private let api: PipelineAPI = APIClient()
    
    init() {
        self.dateService = DateService()
    }
    
    func getConfig(
        _ serviceType: ServiceType,
        baseUrl: String,
        projectId: String,
        token: String
    ) async throws -> Config {
        let headers: [String: String]
        switch serviceType {
        case .gitlab:
            headers = ["PRIVATE-TOKEN" : token]
        case .github:
            headers = [
                "Accept": "application/vnd.github.v3+json",
                "Authorization": "bearer \(token)"
            ]
        }
        let project = try await api.getProjectName(
            baseUrl: baseUrl,
            headers: headers,
            projectId: projectId,
            token: token
        )
        return Config(
            id: UUID().uuidString,
            baseUrl: baseUrl,
            projectId: projectId,
            token: token,
            repositoryName: project.name,
            serviceType: serviceType)
    }
    
    func getPipelines(pipelineCount: Int) async throws -> [PipelineResult]{
        let configs = ConfigurationService.getConfigurations()
        //count number of pipelines per repository
        var pipelineCountPerRepo = pipelineCount
        if(configs.count != 0 && pipelineCount > 1){
            pipelineCountPerRepo  = Int((Double(pipelineCount) / Double(configs.count)).rounded(.up))
        }
        var results: [PipelineResult] = []
        var pipelinesWithRepoName: [PipelineWithRepoName] = []
        //Get pipelines from API
        for config in configs {
            let headers: [String: String]
            switch config.serviceType {
            case .gitlab:
                headers = ["PRIVATE-TOKEN" : config.token]
            case .github:
                headers = [
                    "Accept": "application/vnd.github.v3+json",
                    "Authorization": "bearer \(config.token)"
                ]
            }
            let pipelines = try await api.getPipelines(
                config: config,
                headers: headers,
                pipelineCount: pipelineCountPerRepo
            )
            for pipeline in pipelines {
                pipelinesWithRepoName.append(PipelineWithRepoName(
                    pipeline: pipeline,
                    name: config.repositoryName,
                    date: try dateService.parse(date: pipeline.updated_at),
                    serviceType: config.serviceType)
                )
            }
        }
        //Sort pipelines according to date
        pipelinesWithRepoName.sort{
            $0.date > $1.date
        }
        //Create PipelineResult objects
        for pipeline in pipelinesWithRepoName {
            let duration = try dateService.format(from: try dateService.parse(date: pipeline.pipeline.created_at), to: try dateService.parse(date: pipeline.pipeline.updated_at))
            let age = try dateService.format(from: try dateService.parse(date: pipeline.pipeline.updated_at), to: Date())
            let result = PipelineResult(
                id: pipeline.pipeline.id,
                ref: pipeline.pipeline.ref,
                status: pipeline.pipeline.status,
                duration: duration,
                age: age,
                url: pipeline.pipeline.web_url,
                repositoryName: pipeline.repositoryName,
                serviceType: pipeline.serviceType)
            results.append(result)
        }
        //Sort pipelines according to date
        pipelinesWithRepoName.sort{
            $0.date > $1.date
        }
        //Return rigth number of pipelines
        return results.enumerated().filter { $0.offset < pipelineCount }.map { $0.element }
    }
}
class PipelineWithRepoName{
    let pipeline: Pipeline
    let date: Date
    let repositoryName: String
    let serviceType: ServiceType
    
    init(pipeline: Pipeline, name: String, date: Date, serviceType: ServiceType) {
        self.pipeline = pipeline
        self.date = date
        self.repositoryName = name
        self.serviceType = serviceType
    }
}

class ConfigurationService {
    private static let appGroup = "DxHeroes.Pipeliner.shared"
    private static let configKey = "pipeliner.configuration"
    
    static func addConfiguration(config: Config) -> [Config] {
        var saved = ConfigurationService.getConfigurations()
        saved.append(config)
        ConfigurationService.setConfigurations(configs: saved)
        return saved
    }
    
    static func deleteConfiguration(id: String) -> [Config] {
        let saved = ConfigurationService.getConfigurations()
        let deleted = saved.filter(){$0.id != id}
        ConfigurationService.setConfigurations(configs: deleted)
        return deleted
    }
    
    private static func setConfigurations(configs: [Config]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(configs) {
            UserDefaults(suiteName: appGroup)!.setValue(encoded, forKey: configKey)
            UserDefaults(suiteName: appGroup)!.synchronize()
        } else {
            print("ERROR")
        }
    }
    
    static func getConfigurations() -> [Config] {
        if let configJson =  UserDefaults(suiteName: appGroup)?.value(forKey: configKey) as? Data {
            let decoder = JSONDecoder()
            if let configs = try? decoder.decode([Config].self, from: configJson) {
                return configs
            }
        }
        return []
    }
}

//private struct ServiceResolver {
//    private let gitHubService: GitHubService
//    private let gitLabService: PipelineAPI
//
//    init() {
//        self.gitHubService = GitHubService()
//        self.gitLabService = APIClient()
//    }
//
//    func resolve(_ serviceType: ServiceType) -> IService {
//        switch serviceType {
//        case .github:
//            return self.gitHubService
//        case .gitlab:
//            return self.gitLabService
//        }
//    }
//}
