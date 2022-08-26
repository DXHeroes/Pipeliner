//
//  PipelinerWidgetEntryView.swift
//  PipelinerWidgetExtension
//
//  Created by Jan Kučera on 26.08.2022.
//

import SwiftUI
import WidgetKit

struct PipelinerWidgetEntryView: View {
    var entry: SimpleEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        ZStack {
            Colors.widgetBackground
                .edgesIgnoringSafeArea(.all)
            if (entry.pipelines.isEmpty) {
                Text("No data")
                    .foregroundColor(Colors.white60)
            } else {
                VStack(spacing: 0) {
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

struct PipelinerWidgetEntryView_Previews: PreviewProvider {
    static var previews: some View {
        PipelinerWidgetEntryView(entry: SimpleEntry.MockData.smallWidget())
            .previewContext(WidgetPreviewContext(family: .systemSmall))

        PipelinerWidgetEntryView(entry: SimpleEntry.MockData.mediumWidget())
            .previewContext(WidgetPreviewContext(family: .systemMedium))

        PipelinerWidgetEntryView(entry: SimpleEntry.MockData.largeWidget())
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
