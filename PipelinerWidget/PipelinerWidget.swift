//
//  PipelinerWidget.swift
//  PipelinerWidget
//
//  Created by dx hero on 03.09.2020.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    let service: PipelinerService = PipelinerService()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry.MockData.smallWidget()
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
            return 6
        @unknown default:
            return 1
        }
    }
}



struct PipelinerWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        ZStack {
            Colors.widgetBackground
                .edgesIgnoringSafeArea(.all)
            if (entry.pipelines.isEmpty) {
                Text("No data")
                    .foregroundColor(Colors.white60)
            } else {
                VStack {
                    ForEach(
                        Array(entry.pipelines.enumerated()),
                        id: \.element.id
                    ) { index, pipeline in
                        PipelineRowView(
                            pipeline: pipeline,
                            isOdd: index % 2 != 0
                        )
                    }
                }
            }
        }
    }
}

@main
struct PipelinerWidget: Widget {
    let kind: String = "PipelinerWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: ConfigurationIntent.self,
            provider: Provider()
        ) { entry in
            PipelinerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Pipeliner Widget")
        .description("See your pipelines!")
    }
}

// MARK: - Previews

struct PipelinerWidget_Previews: PreviewProvider {
    static var previews: some View {
        PipelinerWidgetEntryView(entry: SimpleEntry.MockData.smallWidget())
            .previewContext(WidgetPreviewContext(family: .systemSmall))

        PipelinerWidgetEntryView(entry: SimpleEntry.MockData.mediumWidget())
            .previewContext(WidgetPreviewContext(family: .systemMedium))

        PipelinerWidgetEntryView(entry: SimpleEntry.MockData.largeWidget())
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
