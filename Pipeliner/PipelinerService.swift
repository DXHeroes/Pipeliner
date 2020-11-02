//
//  PipelinerService.swift
//  Pipeliner
//
//  Created by dx hero on 03.09.2020.
//

import Foundation

class PipelinerService {
    internal let gitLabService: GitLabService
    internal let dateService: DateService
    
    init() {
        self.gitLabService = GitLabService()
        self.dateService = DateService()
    }
    
    func getProjectName(baseUrl: String, projectId: String, token: String, _ completion: @escaping (Result<String>) -> Void) {
        do {
            let projectName = try gitLabService.getProjectName(baseUrl: baseUrl, projectId: projectId, token: token)
            completion(.success(projectName))
        } catch  {
            completion(.failure(error))
        }
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
                let pipelines = try gitLabService.getPipelines(config: config, pipelineCount: pipelineCountPerRepo)
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
