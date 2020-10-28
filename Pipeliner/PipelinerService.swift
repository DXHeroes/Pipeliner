//
//  PipelinerService.swift
//  Pipeliner
//
//  Created by dx hero on 03.09.2020.
//

import Foundation

class PipelinerService {
    internal let dateService: DateService
    private let resolver = ServiceResolver()

    init() {
        self.dateService = DateService()
    }
    
    func getConfig(_ serviceType: ServiceType, baseUrl: String, projectId: String, token: String) throws -> Config {
        let service = self.resolver.resolve(serviceType)
        let projectName = try service.getProjectName(baseUrl: baseUrl, projectId: projectId, token: token)
        return Config(
            id: UUID().uuidString,
            baseUrl: baseUrl,
            projectId: projectId,
            token: token,
            repositoryName: projectName,
            serviceType: serviceType)
    }

    func getPipelines(pipelineCount: Int) -> [PipelineResult]{
        let configs = ConfigurationService.getConfigurations()
        //count number of pipelines per repository
        var pipelineCountPerRepo = pipelineCount
        if(configs.count != 0 && pipelineCount > 1){
            pipelineCountPerRepo  = Int((Double(pipelineCount) / Double(configs.count)).rounded(.up))
        }
        do {
            var results: [PipelineResult] = []
            var pipelinesWithRepoName: [PipelineWithRepoName] = []
            //Get pipelines from API
            for config in configs {
                let service = self.resolver.resolve(config.serviceType)
                let pipelines = try service.getPipelines(config: config, pipelineCount: pipelineCountPerRepo)
                for pipeline in pipelines {
                    pipelinesWithRepoName.append(PipelineWithRepoName(pipeline: pipeline, name: config.repositoryName, date: try dateService.parse(date: pipeline.updated_at)))
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
                results.append(PipelineResult(id: pipeline.pipeline.id, ref: pipeline.pipeline.ref, status: pipeline.pipeline.status == PipelineStatus.SUCCESS.rawValue ? PipelineStatus.SUCCESS : PipelineStatus.FAILED, duration: duration, age: age, url: pipeline.pipeline.web_url, repositoryName: pipeline.repositoryName))
            }
            //Return rigth number of pipelines
            return results.enumerated().filter { $0.offset < pipelineCount }.map { $0.element }
        } catch  {
            print("err", error)
            return []
        }
    }
}
class PipelineWithRepoName{
    let pipeline: Pipeline
    let date: Date
    let repositoryName: String
    
    init(pipeline: Pipeline, name: String, date: Date) {
        self.pipeline = pipeline
        self.date = date
        self.repositoryName = name
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

private struct ServiceResolver {
    private let gitHubService: GitHubService
    private let gitLabService: GitLabService

    init() {
        self.gitHubService = GitHubService()
        self.gitLabService = GitLabService()
    }

    func resolve(_ serviceType: ServiceType) -> IService {
        switch serviceType {
        case .GITHUB:
            return self.gitHubService
        case .GITLAB:
            return self.gitLabService
        }
    }
}
