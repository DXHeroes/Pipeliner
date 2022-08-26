//
//  PipelinerWidget.swift
//  PipelinerWidget
//
//  Created by dx hero on 03.09.2020.
//

import SwiftUI
import WidgetKit

@main
struct PipelinerWidget: Widget {
    let kind: String = "PipelinerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider()
        ) { entry in
            PipelinerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Pipeliner Widget")
        .description("See your pipelines!")
    }
}

public struct Provider: TimelineProvider {
    public typealias Entry = SimpleEntry
    let service: PipelinerService = PipelinerService()

    public func placeholder(in context: Context) -> SimpleEntry {
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

    public func getSnapshot(
        in context: Context,
        completion: @escaping (SimpleEntry) -> Void
    ) {
        // Snapshot of current state
        // Get here real data somehow
        completion(SimpleEntry.MockData.largeWidget())
    }

    public func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<SimpleEntry>) -> Void
    ) {
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 3, to: Date())!
        // Get here real data somehow
        let timeline = Timeline(
            entries: [SimpleEntry.MockData.largeWidget()],
            policy: .after(nextUpdate)
        )
        completion(timeline)
    }

}

extension Provider {
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

// let data = try! service.getPipelines(pipelineCount: getPipelineCount(context: context))
