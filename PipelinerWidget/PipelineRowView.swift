//
//  PipelineRowView.swift
//  PipelinerWidgetExtension
//
//  Created by dx hero on 03.09.2020.
//

import SwiftUI
import WidgetKit
struct PipelineRowView: View {
    public let pipeline: PipelineResult
    public let size: WidgetFamily
    public let isLastRow: Bool
    
    var body: some View {
            switch size {
            case .systemSmall:
                VStack(alignment: .center, content: {
                    Text(pipeline.repositoryName.uppercased())
                    Text(pipeline.ref).foregroundColor(.gray)
                    Spacer()
                    if(pipeline.status == PipelineStatus.FAILED) {
                        Image(systemName: "xmark").font(.system(size: 60)).foregroundColor(.red)
                    } else if(pipeline.status == PipelineStatus.SUCCESS) {
                        Image(systemName: "checkmark").font(.system(size: 60)).foregroundColor(.green)
					} else {
						//Text(pipeline.status.rawValue).foregroundColor(.gray)
						Image(systemName: "arrow.triangle.2.circlepath").font(.system(size: 60)).foregroundColor(.yellow)
					}
                    Spacer()
                    Text(pipeline.duration)
                    Text("\(pipeline.age) ago").foregroundColor(.gray)
                })
            default:
                HStack(content: {
                    VStack(alignment: .leading, content: {
                        Text(pipeline.repositoryName.uppercased())
                        Text(pipeline.ref).foregroundColor(.gray)
                    })
                    Spacer()
					if(pipeline.status == PipelineStatus.FAILED) {
						Image(systemName: "xmark").font(.title).foregroundColor(.red)
					} else if(pipeline.status == PipelineStatus.SUCCESS) {
						Image(systemName: "checkmark").font(.title).foregroundColor(.green)
					} else {
						Text(pipeline.status.rawValue).foregroundColor(.gray)
						Image(systemName: "arrow.triangle.2.circlepath").font(.title).foregroundColor(.yellow)
					}
                    VStack(alignment: .leading, content: {
                        Text(pipeline.duration)
                        Text("\(pipeline.age) ago").foregroundColor(.gray)
                    })
                }).foregroundColor(Color.white).padding(.horizontal)
                if(!isLastRow) {
                    Divider()
                }
            }
    }
}


struct PipelineRowView_Previews: PreviewProvider {
    static var previews: some View {
        PipelineRowView(pipeline: PipelineResult(id: 1, ref: "test", status: PipelineStatus.FAILED, duration: "54 min", age: "4 min", url: "url", repositoryName: "Cool Project"), size: .systemMedium, isLastRow: false)
    }
}
