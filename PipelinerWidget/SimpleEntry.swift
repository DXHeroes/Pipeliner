//
//  SimpleEntry.swift
//  PipelinerWidgetExtension
//
//  Created by Jan Kučera on 25.08.2022.
//

import WidgetKit

struct SimpleEntry: TimelineEntry {
    let date: Date
    let error: Bool
    let pipelines: [PipelineResult]

    static func provideOneEntry() -> SimpleEntry {
        let pipelineResult = PipelineResult(
            id: 1,
            ref: "test",
            status: PipelineStatus.FAILED,
            duration: "4 min",
            age: "54 min",
            url: "url",
            repositoryName: "Cool Project",
            serviceType: ServiceType.github
        )
        return SimpleEntry(date: Date(), error: false, pipelines: [pipelineResult])
    }
    static func provideMultipleEntries() -> SimpleEntry {
        let pipelineResult1 = PipelineResult(
            id: 1,
            ref: "test",
            status: PipelineStatus.SUCCESS,
            duration: "4 min",
            age: "54 min",
            url: "url",
            repositoryName: "Cool Project",
            serviceType: ServiceType.github
        )
        let pipelineResult2 = PipelineResult(
            id: 2,
            ref: "test",
            status: PipelineStatus.FAILED,
            duration: "14 min",
            age: "54 min",
            url: "url",
            repositoryName: "Failing Project",
            serviceType: ServiceType.gitlab
        )
        let pipelineResult3 = PipelineResult(
            id: 3,
            ref: "test",
            status: PipelineStatus.MANUAL,
            duration: "114 min",
            age: "54 min",
            url: "url",
            repositoryName: "Another Cool Project",
            serviceType: ServiceType.github
        )
        return SimpleEntry(
            date: Date(),
            error: false,
            pipelines: [
                pipelineResult1, pipelineResult2,
                pipelineResult3
            ]
        )
    }
}
