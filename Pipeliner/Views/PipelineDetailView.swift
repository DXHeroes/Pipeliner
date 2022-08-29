//
//  PipelineDetailView.swift
//  Pipeliner
//
//  Created by dx hero on 07.09.2020.
//

import SwiftUI

struct PipelineDetailView: View {

    public let index: Int
    public let pipeline: PipelineResult

    var body: some View {

        HStack {
            pipeline.serviceType.servicePickerIcon()
                .padding(.trailing, 8)
            VStack(alignment: .leading) {
                Text(pipeline.repositoryName.uppercased())
                    .lineLimit(1)
                    .truncationMode(.tail)
                Text(pipeline.ref)
                    .foregroundColor(Colors.white60)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            Spacer()
            VStack {
                if pipeline.status.requiresTitle() {
                    HStack(alignment: .center) {
                        Text(pipeline.status.readableTitle())
                            .foregroundColor(Colors.white60)
                        pipeline.status.icon()
                    }
                } else {
                    pipeline.status.icon()
                }
            }
            .padding(.trailing)
            VStack(alignment: .leading) {
                Text(pipeline.duration)
                Text("\(pipeline.age) ago")
                    .foregroundColor(Colors.white60)
            }
            .frame(width: 80, height: 40)
            Link(destination: URL(string: pipeline.url)!) {
                Image(systemName: "link")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            .padding(.trailing)
            .onHover { $0 ? NSCursor.pointingHand.push() : NSCursor.pop() }
        }
        .foregroundColor(Color.white)
        .padding(.horizontal)
        .padding(.vertical, index % 2 == 0 ? 8 : 0)
        .background(index % 2 == 0 ? Colors.white4 : Colors.purple)

    }
}

// MARK: - Preview

struct PipelineDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PipelineDetailView(
            index: 0,
            pipeline: PipelineResult(
                id: 1,
                ref: "renovate/minor-version-update",
                status: PipelineStatus.FAILED,
                duration: "54 min",
                age: "4 min",
                url: "url",
                repositoryName: "Cool Project",
                serviceType: ServiceType.github
            )
        )
        .background(Colors.purple)

        PipelineDetailView(
            index: 0,
            pipeline: PipelineResult(
                id: 1,
                ref: "renovate/minor-version-update",
                status: PipelineStatus.MANUAL,
                duration: "54 min",
                age: "4 min",
                url: "url",
                repositoryName: "Cool Project",
                serviceType: ServiceType.github
            )
        )
        .background(Colors.darkblue)
        .background(Colors.white4)

        PipelineDetailView(
            index: 0,
            pipeline: PipelineResult(
                id: 1,
                ref: "renovate/minor-version-update",
                status: PipelineStatus.PREPARING,
                duration: "54 min",
                age: "4 min",
                url: "url",
                repositoryName: "Cool Project",
                serviceType: ServiceType.github
            )
        )
        .background(Colors.purple)

        PipelineDetailView(
            index: 0,
            pipeline: PipelineResult(
                id: 1,
                ref: "renovate/minor-version-update",
                status: PipelineStatus.SCHEDULED,
                duration: "54 min",
                age: "4 min",
                url: "url",
                repositoryName: "Cool Project",
                serviceType: ServiceType.github
            )
        )
        .background(Colors.darkblue)
        .background(Colors.white4)
    }
}
