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
        return SimpleEntry(date: Date(), pipelines: [PipelineResult(id: 1, ref: "test", status: PipelineStatus.FAILED, duration: "54 min", age: "4 min", url: "url", repositoryName: "Cool Project", serviceType: ServiceType.GITHUB)], error: false)
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry: SimpleEntry
        // use mock data
        if(context.isPreview) {
            switch context.family {
            case .systemSmall:
                entry = SimpleEntry(date: Date(), pipelines: [PipelineResult(id: 1, ref: "test", status: PipelineStatus.FAILED, duration: "4 min", age: "54 min", url: "url", repositoryName: "Cool Project", serviceType: ServiceType.GITHUB)], error: false)
            case .systemMedium:
                entry = SimpleEntry(date: Date(), pipelines: [PipelineResult(id: 1, ref: "fix:test", status: PipelineStatus.SUCCESS, duration: "4 min", age: "54 min", url: "url", repositoryName: "Cool Project", serviceType: ServiceType.GITHUB), PipelineResult(id: 2, ref: "feat: make it cooler", status: PipelineStatus.SUCCESS, duration: "6 min", age: "4 hours", url: "url", repositoryName: "Second Project", serviceType: ServiceType.GITHUB), PipelineResult(id: 3, ref: "chore: clean up", status: PipelineStatus.FAILED, duration: "9 min", age: "8 hours", url: "url", repositoryName: "Cool Project", serviceType: ServiceType.GITHUB)
                ], error: false)
            case .systemLarge:
                entry = SimpleEntry(date: Date(), pipelines: [PipelineResult(id: 1, ref: "fix:test", status: PipelineStatus.SUCCESS, duration: "4 min", age: "54 min", url: "url", repositoryName: "Cool Project", serviceType: ServiceType.GITHUB), PipelineResult(id: 2, ref: "feat: make it cooler", status: PipelineStatus.SUCCESS, duration: "6 min", age: "4 hours", url: "url", repositoryName: "Second Project", serviceType: ServiceType.GITHUB), PipelineResult(id: 3, ref: "chore: clean up", status: PipelineStatus.FAILED, duration: "9 min", age: "8 hours", url: "url", repositoryName: "Cool Project", serviceType: ServiceType.GITHUB), PipelineResult(id: 4, ref: "fix:test", status: PipelineStatus.SUCCESS, duration: "4 min", age: "9 hours", url: "url", repositoryName: "Cool Project", serviceType: ServiceType.GITHUB), PipelineResult(id: 5, ref: "feat: make it cooler", status: PipelineStatus.SUCCESS, duration: "6 min", age: "10 hours", url: "url", repositoryName: "Second Project", serviceType: ServiceType.GITHUB), PipelineResult(id: 6, ref: "chore: clean up", status: PipelineStatus.FAILED, duration: "9 min", age: "13 hours", url: "url", repositoryName: "Cool Project", serviceType: ServiceType.GITHUB)
                ], error: false)
            default:
                entry = SimpleEntry(date: Date(), pipelines: [PipelineResult(id: 1, ref: "fix:test", status: PipelineStatus.SUCCESS, duration: "4 min", age: "54 min", url: "url", repositoryName: "Cool Project", serviceType: ServiceType.GITHUB), PipelineResult(id: 2, ref: "feat: make it cooler", status: PipelineStatus.SUCCESS, duration: "6 min", age: "4 hours", url: "url", repositoryName: "Second Project", serviceType: ServiceType.GITHUB), PipelineResult(id: 3, ref: "chore: clean up", status: PipelineStatus.FAILED, duration: "9 min", age: "8 hours", url: "url", repositoryName: "Cool Project", serviceType: ServiceType.GITHUB)
                ], error: false)
            }
            // use real data
        } else {
            entry = SimpleEntry(date: Date(), pipelines: try! service.getPipelines(pipelineCount: getPipelineCount(context: context)), error: false)
        }
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let now = Date()
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 1, to: now)!
        let data = try! service.getPipelines(pipelineCount: getPipelineCount(context: context))
        let timeline = Timeline(entries: [SimpleEntry(date: Date(), pipelines: data, error: false)], policy: .after(nextUpdate))
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
        default:
            return 2
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let pipelines: [PipelineResult]
    let error: Bool
    
}

struct PipelinerWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {
        ZStack {
            Color("WidgetBackground").edgesIgnoringSafeArea(.all)
            if(entry.pipelines.isEmpty){
                Text("No data").foregroundColor(Color("white-60"))
            } else {
                PipelineListView(pipelines: entry.pipelines, size: family)
            }
        }
    }}

@main
struct PipelinerWidget: Widget {
    let kind: String = "PipelinerWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            PipelinerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Pipeliner Widget")
        .description("See your pipelines!")
    }
}

struct PipelinerWidget_Previews: PreviewProvider {
    static var previews: some View {
        PipelinerWidgetEntryView(entry: SimpleEntry(date: Date(), pipelines: [PipelineResult(id: 1, ref: "test", status: PipelineStatus.FAILED, duration: "54 min", age: "4 min", url: "url", repositoryName: "Cool project", serviceType: ServiceType.GITHUB)], error: false))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
