//
//  PipelineView.swift
//  Pipeliner
//
//  Created by dx hero on 21.12.2020.
//

import SwiftUI

struct PipelineView: View {
    public let pipelines: [PipelineResult]
    
    var body: some View {
        ZStack(alignment: .top, content: {
            Color("purple")
            VStack {
                Text("Pipelines").font(.system(size: 24)).foregroundColor(Color("white-60")).frame(maxWidth: .infinity, alignment: .topLeading).padding()
                if(pipelines.count != 0) {
                    HStack(content: {
                        VStack(alignment: .leading, content: {
                            Text("name".uppercased()).font(.system(size: 12)).foregroundColor(Color("white-60"))
                        })
                        Spacer()
                        VStack(alignment: .trailing, content: {
                            Text("status".uppercased()).font(.system(size: 12)).foregroundColor(Color("white-60"))
                        })
                        VStack(alignment: .leading, content: {
                            Text("duration".uppercased()).font(.system(size: 12)).foregroundColor(Color("white-60"))
                        }).frame(width: 90)
                        VStack(alignment: .leading, content: {
                                Text("detail".uppercased()).font(.system(size: 12)).foregroundColor(Color("white-60"))                    })
                    }).padding(.horizontal)
                    ForEach(0..<pipelines.count){ index in
                        PipelineDetailView(index: index, pipeline: pipelines[index])
                    }
                }
                else {
                    Text("There are no data").font(.system(size: 18)).foregroundColor(Color("white-60"))
                }
            }
        }).padding(.top, 40).padding(.bottom, 120).padding(.horizontal, 30)
    }
}

struct PipelineView_Previews: PreviewProvider {
    static var previews: some View {
        PipelineView(pipelines: [ PipelineResult(id: 1, ref: "test", status: PipelineStatus.FAILED, duration: "54 min", age: "4 min", url: "url", repositoryName: "Cool Project", serviceType: ServiceType.GITLAB),])
    }
}
