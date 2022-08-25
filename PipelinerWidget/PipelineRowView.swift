//
//  PipelineRowView.swift
//  PipelinerWidgetExtension
//
//  Created by dx hero on 03.09.2020.
//

import SwiftUI
import WidgetKit

struct PipelineRowView: View {

    @Environment(\.widgetFamily) var widgetFamily

    public let pipeline: PipelineResult
    public let size: WidgetFamily
    public let isOdd: Bool
    
    var body: some View {

        switch widgetFamily {
        case .systemSmall:
            VStack {
                HStack {
                    pipeline.serviceType.servicePickerIcon()
                    Text(pipeline.repositoryName.uppercased())
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                Text(pipeline.ref)
                    .foregroundColor(Colors.white60)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Spacer()
                if (pipeline.status == PipelineStatus.FAILED) {
                    Image(systemName: "xmark")
                        .font(.system(size: 60))
                        .foregroundColor(Colors.error)
                } else if (pipeline.status == PipelineStatus.SUCCESS) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 60))
                        .foregroundColor(Colors.lightteal)
                } else {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.system(size: 60))
                        .foregroundColor(Colors.warning)
                }
                Spacer()
                Text(pipeline.duration)
                Text("\(pipeline.age) ago")
                    .foregroundColor(.secondary)
            }
            .padding()
            .environment(\.colorScheme, .dark)
        default:
            HStack {
                pipeline.serviceType.servicePickerIcon()
                VStack(alignment: .leading) {
                    Text(pipeline.repositoryName.uppercased())
                        .lineLimit(1)
                    Text(pipeline.ref)
                        .foregroundColor(Colors.white60)
                        .lineLimit(1)
                }
                Spacer()
                if (pipeline.status == PipelineStatus.FAILED) {
                    Image(systemName: "xmark")
                        .font(.title)
                        .foregroundColor(Colors.error)
                } else if (pipeline.status == PipelineStatus.SUCCESS) {
                    Image(systemName: "checkmark")
                        .font(.title)
                        .foregroundColor(Colors.lightteal)
                } else {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.title)
                        .foregroundColor(Colors.warning)
                }
                VStack(alignment: .leading) {
                    Text(pipeline.duration)
                    Text("\(pipeline.age) ago")
                        .foregroundColor(Colors.white60)
                }
                .frame(width: 80, height: 40)
            }
            .foregroundColor(Color.white)
            .padding(.horizontal)
            .padding(.vertical, isOdd ? 0 : 8)
            .background(isOdd ? Colors.widgetBackground : Colors.white4)
            .environment(\.colorScheme, .dark)
        }

    }
}

// MARK: - Preview

struct PipelineRowView_Previews: PreviewProvider {

    static var previews: some View {
        PipelineRowView(
            pipeline: PipelineResult(
                id: 1,
                ref: "test",
                status: PipelineStatus.FAILED,
                duration: "54 min",
                age: "4 min",
                url: "url",
                repositoryName: "Cool Project",
                serviceType: ServiceType.gitlab
            ),
            size: .systemMedium,
            isOdd: false
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))

        PipelineRowView(
            pipeline: PipelineResult(
                id: 1,
                ref: "test",
                status: PipelineStatus.FAILED,
                duration: "54 min",
                age: "4 min",
                url: "url",
                repositoryName: "Cool Project",
                serviceType: ServiceType.gitlab
            ),
            size: .systemMedium,
            isOdd: false
        )
        .previewContext(WidgetPreviewContext(family: .systemMedium))

        PipelineRowView(
            pipeline: PipelineResult(
                id: 1,
                ref: "test",
                status: PipelineStatus.FAILED,
                duration: "54 min",
                age: "4 min",
                url: "url",
                repositoryName: "Cool Project",
                serviceType: ServiceType.gitlab
            ),
            size: .systemMedium,
            isOdd: false
        )
        .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
    
}
