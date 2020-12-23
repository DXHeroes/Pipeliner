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
    public let isOdd: Bool
    
    var body: some View {
        switch size {
        case .systemSmall:
            VStack(alignment: .center, content: {
                Text(pipeline.repositoryName.uppercased())
                Text(pipeline.ref).foregroundColor(.gray)
                Spacer()
                if(pipeline.status == PipelineStatus.FAILED) {
                    Image(systemName: "xmark").font(.system(size: 60)).foregroundColor(Color("error"))
                } else {
                    Image(systemName: "checkmark").font(.system(size: 60)).foregroundColor(Color("lightteal"))
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
                    Image(systemName: "xmark").font(.title).foregroundColor(Color("error"))
                } else {
                    Image(systemName: "checkmark").font(.title).foregroundColor(Color("lightteal"))
                }
                VStack(alignment: .leading, content: {
                    Text(pipeline.duration)
                    Text("\(pipeline.age) ago").foregroundColor(.gray)
                })
            }).foregroundColor(Color.white).padding(.horizontal).padding([.vertical], isOdd ? 0 : 8) .background(isOdd ? Color("WidgetBackground") : Color("white-4"))
        }
    }
}


struct PipelineRowView_Previews: PreviewProvider {
    static var previews: some View {
        PipelineRowView(pipeline: PipelineResult(id: 1, ref: "test", status: PipelineStatus.FAILED, duration: "54 min", age: "4 min", url: "url", repositoryName: "Cool Project"), size: .systemMedium, isOdd: false)
    }
}
