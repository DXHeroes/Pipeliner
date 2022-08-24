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
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack(content: {
            Image( nsImage: pipeline.serviceType.serviceIcon())
            VStack(alignment: .leading, content: {
                HStack(content: {
                    Text(pipeline.repositoryName.uppercased()).lineLimit(1)
                })
                Text(pipeline.ref).foregroundColor(Color("white-60")).lineLimit(1)
            })
            Spacer()
            VStack(alignment: .leading, content: {
                if pipeline.status.requiresTitle() {
                    HStack(alignment: .center, content: {
                        Text(pipeline.status.readableTitle()).foregroundColor(Color("white-60"))
                        pipeline.status.icon()
                    })
                } else {
                    pipeline.status.icon()
                }
            })
            VStack(alignment: .leading, content: {
                Text(pipeline.duration)
                Text("\(pipeline.age) ago").foregroundColor(Color("white-60"))
            }).frame(width: 80, height: 40)
            Link(destination: URL(string: pipeline.url)!) {
                Image(systemName: "link").font(.title2).foregroundColor(.blue)
            }.padding(.horizontal).onHover { inside in
                if inside {
                    NSCursor.pointingHand.push()
                } else {
                    NSCursor.pop()
                }
            }
        }).foregroundColor(Color.white).padding(.horizontal).padding([.vertical], self.index % 2 == 0 ? 8 : 0) .background(self.index % 2 == 0 ? Color("white-4") : Color("purple"))
    }
}

struct PipelineDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PipelineDetailView(index: 0, pipeline: PipelineResult(id: 1, ref: "renovate/minor-version-update", status: PipelineStatus.FAILED, duration: "54 min", age: "4 min", url: "url", repositoryName: "Cool Project", serviceType: ServiceType.github))
    }
}
