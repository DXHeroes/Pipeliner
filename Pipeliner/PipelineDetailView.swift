//
//  PipelineDetailView.swift
//  Pipeliner
//
//  Created by dx hero on 07.09.2020.
//

import SwiftUI

struct PipelineDetailView: View {
    public let pipeline: PipelineResult
    public let isLastRow: Bool

    @Environment(\.colorScheme) var colorScheme
    let status = (failed: Color(.red), success: Color(.green))
    let detailTextDark: Color = .white
    let detailTextReferenceDark: Color = .gray
    let linkActionDark: Color = .blue

    var body: some View {
        HStack(content: {
            VStack(alignment: .leading, content: {
              Text(pipeline.repositoryName.uppercased())
                Text(pipeline.ref).foregroundColor(detailTextReferenceDark)
            })
            Spacer()
            if(pipeline.status == PipelineStatus.FAILED) {
              Image(systemName: "xmark").font(.title).foregroundColor(status.failed)
            } else {
              Image(systemName: "checkmark").font(.title).foregroundColor(status.success)
            }
            VStack(alignment: .leading, content: {
                Text(pipeline.duration)
                Text("\(pipeline.age) ago").foregroundColor(detailTextReferenceDark)
            })
            Link(destination: URL(string: pipeline.url)!) {
                Image(systemName: "link").font(.title2).foregroundColor(linkActionDark)
            }.padding(.horizontal)
        }).foregroundColor(detailTextDark).padding(.horizontal)
        if(!isLastRow) {
            Divider()
        }
    }
}

struct PipelineDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PipelineDetailView(pipeline: PipelineResult(id: 1, ref: "test", status: PipelineStatus.FAILED, duration: "54 min", age: "4 min", url: "url", repositoryName: "Cool Project"), isLastRow: false)
    }
}
