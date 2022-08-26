//
//  CurrentlyUnusedIntentProvider.swift
//  Pipeliner
//
//  Created by Jan Kučera on 26.08.2022.
//

import Foundation
import WidgetKit

#warning("Currently not member of any target!!")

struct Provider2: IntentTimelineProvider {
    let service: PipelinerService = PipelinerService()

    func placeholder(in context: Context) -> SimpleEntry {
        switch context.family {
        case .systemSmall:
            return SimpleEntry.MockData.smallWidget()
        case .systemMedium:
            return SimpleEntry.MockData.mediumWidget()
        case .systemLarge:
            return SimpleEntry.MockData.largeWidget()
        @unknown default:
            return SimpleEntry.MockData.smallWidget()
        }
    }

    func getSnapshot(
        for configuration: ConfigurationIntent,
        in context: Context,
        completion: @escaping (SimpleEntry) -> ()
    ) {
        let entry: SimpleEntry
        if (context.isPreview) { // use mock data
            switch context.family {
            case .systemSmall:
                entry = SimpleEntry.MockData.smallWidget()
            case .systemMedium:
                entry = SimpleEntry.MockData.mediumWidget()
            case .systemLarge:
                entry = SimpleEntry.MockData.largeWidget()
            default:
                entry = SimpleEntry.MockData.smallWidget()
            }
        } else { // use real data
            entry = SimpleEntry(
                date: Date(),
                error: false,
                pipelines: try! service.getPipelines(pipelineCount: getPipelineCount(context: context))
            )
        }
        completion(entry)
    }

    func getTimeline(
        for configuration: ConfigurationIntent,
        in context: Context,
        completion: @escaping (Timeline<Entry>) -> ()
    ) {
        let now = Date()
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 1, to: now)!
        let data = try! service.getPipelines(pipelineCount: getPipelineCount(context: context))
        let timeline = Timeline(
            entries: [SimpleEntry(
                date: Date(),
                error: false,
                pipelines: data
            )],
            policy: .after(nextUpdate)
        )
        completion(timeline)
    }

    func getPipelineCount(context: Context) -> Int {
        switch context.family {
        case .systemSmall:
            return 1
        case .systemMedium:
            return 3
        case .systemLarge:
            return 7
        @unknown default:
            return 1
        }
    }
}
