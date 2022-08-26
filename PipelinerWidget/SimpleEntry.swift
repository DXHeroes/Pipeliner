//
//  SimpleEntry.swift
//  PipelinerWidgetExtension
//
//  Created by Jan Kučera on 25.08.2022.
//

import WidgetKit

public struct SimpleEntry: TimelineEntry {
    public let date: Date
    let pipelines: [PipelineResult]

    struct MockData {
        static private let pipelineResult1 = PipelineResult(
            id: 1,
            ref: "test",
            status: PipelineStatus.SUCCESS,
            duration: "4 min",
            age: "54min",
            url: "url",
            repositoryName: "Cool Project",
            serviceType: ServiceType.github
        )
        static private let pipelineResult2 = PipelineResult(
            id: 2,
            ref: "test",
            status: PipelineStatus.FAILED,
            duration: "14 min",
            age: "54min",
            url: "url",
            repositoryName: "Failing Project",
            serviceType: ServiceType.gitlab
        )
        static private let pipelineResult3 = PipelineResult(
            id: 3,
            ref: "test",
            status: PipelineStatus.MANUAL,
            duration: "114 min",
            age: "54min",
            url: "url",
            repositoryName: "Another Cool Project",
            serviceType: ServiceType.github
        )
        static private let pipelineResult4 = PipelineResult(
            id: 4,
            ref: "test",
            status: PipelineStatus.SUCCESS,
            duration: "4 min",
            age: "54min",
            url: "url",
            repositoryName: "Cool Project",
            serviceType: ServiceType.github
        )
        static private let pipelineResult5 = PipelineResult(
            id: 5,
            ref: "test",
            status: PipelineStatus.FAILED,
            duration: "14 min",
            age: "54min",
            url: "url",
            repositoryName: "Failing Project",
            serviceType: ServiceType.gitlab
        )
        static private let pipelineResult6 = PipelineResult(
            id: 6,
            ref: "test",
            status: PipelineStatus.MANUAL,
            duration: "114 min",
            age: "54min",
            url: "url",
            repositoryName: "Another Cool Project",
            serviceType: ServiceType.github
        )
        static private let pipelineResult7 = PipelineResult(
            id: 7,
            ref: "test",
            status: PipelineStatus.SUCCESS,
            duration: "4 min",
            age: "54min",
            url: "url",
            repositoryName: "Cool Project",
            serviceType: ServiceType.github
        )

        static func smallWidget() -> SimpleEntry {
            SimpleEntry(
                date: Date(),
                pipelines: [pipelineResult1]
            )
        }
        static func mediumWidget() -> SimpleEntry {
            SimpleEntry(
                date: Date(),
                pipelines: [
                    pipelineResult1,
                    pipelineResult2,
                    pipelineResult3
                ]
            )
        }
        static func largeWidget() -> SimpleEntry {
            SimpleEntry(
                date: Date(),
                pipelines: [
                    pipelineResult1, pipelineResult2,
                    pipelineResult3, pipelineResult4,
                    pipelineResult5, pipelineResult6,
                    pipelineResult7
                ]
            )
        }
    }
}
