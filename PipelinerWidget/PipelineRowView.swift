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
    //@Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        switch size {
        case .systemSmall:
            VStack(alignment: .center, content: {
                HStack(content: {
                    Image(nsImage: pipeline.serviceType.serviceIcon())
                    Text(pipeline.repositoryName.uppercased()).lineLimit(1)
                }).padding(.top, 5)
                Text(pipeline.ref).foregroundColor(Color("white-60")).lineLimit(1)
                Spacer()
                if(pipeline.status == PipelineStatus.FAILED) {
                    Image(systemName: "xmark").font(.system(size: 60)).foregroundColor(Color("error"))
                } else if(pipeline.status == PipelineStatus.SUCCESS) {
                    Image(systemName: "checkmark").font(.system(size: 60)).foregroundColor(Color("ligtteal"))
                } else {
                    Image(systemName: "arrow.triangle.2.circlepath").font(.system(size: 60)).foregroundColor(Color("warning"))
                }
                Spacer()
                Text(pipeline.duration)
                Text("\(pipeline.age) ago").foregroundColor(Color("white-60"))
            }).environment(\.colorScheme, .dark)
        default:
            HStack(content: {
                Image( nsImage: pipeline.serviceType.serviceIcon())
                VStack(alignment: .leading, content: {
                    Text(pipeline.repositoryName.uppercased()).lineLimit(1)
                    Text(pipeline.ref).foregroundColor(Color("white-60")).lineLimit(1)
                })
                Spacer()
                if(pipeline.status == PipelineStatus.FAILED) {
                    Image(systemName: "xmark").font(.title).foregroundColor(Color("error"))
                } else if(pipeline.status == PipelineStatus.SUCCESS) {
                    Image(systemName: "checkmark").font(.title).foregroundColor(Color("lightteal"))
                } else {
                    Image(systemName: "arrow.triangle.2.circlepath").font(.title).foregroundColor(Color("warning"))
                }
                VStack(alignment: .leading, content: {
                    Text(pipeline.duration)
                    Text("\(pipeline.age) ago").foregroundColor(Color("white-60"))
                }).frame(width: 80, height: 40)
            }).foregroundColor(Color.white).padding(.horizontal).padding([.vertical], isOdd ? 0 : 8).background(isOdd ? Color("WidgetBackground") : Color("white-4")).environment(\.colorScheme, .dark)
        }
    }
}


struct PipelineRowView_Previews: PreviewProvider {
    static var previews: some View {
        PipelineRowView(pipeline: PipelineResult(id: 1, ref: "test", status: PipelineStatus.FAILED, duration: "54 min", age: "4 min", url: "url", repositoryName: "Cool Project", serviceType: ServiceType.GITLAB), size: .systemMedium, isOdd: false)
    }
}
