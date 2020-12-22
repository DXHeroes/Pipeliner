//
//  ContentView.swift
//  Pipeliner
//
//  Created by dx hero on 03.09.2020.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    internal let pipelinerService: PipelinerService = PipelinerService()
    @State private var pipelines: [PipelineResult]
    @State private var configurations: [Config]
    @Environment(\.colorScheme) var colorScheme
    
    init() {
        _pipelines = State(initialValue:  pipelinerService.getPipelines(pipelineCount: 10))
        _configurations = State(initialValue:  ConfigurationService.getConfigurations())
    }
    
    var body: some View {
        ZStack {
            Color("darkblue")
            HStack(content: {
                VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, content: {
                    AddConfigurationView(onAdd: { baseUrl, token, projectId, serviceType in
                        if let config = try? pipelinerService.getConfig(
                            serviceType, baseUrl: baseUrl, projectId: projectId, token: token) {
                            configurations =  ConfigurationService.addConfiguration(config: config)
                            pipelines = pipelinerService.getPipelines(pipelineCount: 10)
                            WidgetCenter.shared.reloadAllTimelines()
                            
                        }
                    })
                    Spacer()
                    ZStack(alignment: .top, content: {
                        Color("purple")
                        VStack {
                            Text("Configurations").font(.system(size: 24)).foregroundColor(Color("white-60")).frame(maxWidth: .infinity, alignment: .topLeading).padding()
                            if(configurations.count != 0) {
                                HStack(content: {
                                    VStack(alignment: .leading, content: {
                                        Text("name".uppercased()).font(.system(size: 12)).foregroundColor(Color("white-60"))
                                    })
                                    Spacer()
                                    VStack(alignment: .leading, content: {
                                            Text("remove".uppercased()).font(.system(size: 12)).foregroundColor(Color("white-60"))                    })
                                }).padding(.horizontal)
                                ForEach(configurations.indices, id: \.self){ index in
                                    HStack(content: {
                                        Image( nsImage: configurations[index].serviceType.serviceIcon(colorScheme: colorScheme))
                                        VStack(alignment: .leading, content: {
                                            Text(configurations[index].repositoryName.uppercased())
                                            Text(configurations[index].baseUrl).foregroundColor(.gray)
                                        })
                                        Spacer()
                                        VStack(alignment: .leading, content: {
                                            DxButton(label: "remove", action: {
                                                        configurations = ConfigurationService.deleteConfiguration(id: configurations[index].id)
                                                        pipelines = pipelinerService.getPipelines(pipelineCount: 10)
                                                        WidgetCenter.shared.reloadAllTimelines()               }, color: Color("error"), shadow: false)
                                        })
                                    }).foregroundColor(Color.white).padding(.horizontal).padding([.vertical], index % 2 == 0 ? 8 : 0).background(index % 2 == 0 ? Color("white-4") : Color("purple"))
                                }
                            } else {
                                Text("There are no data").font(.system(size: 18)).foregroundColor(Color("white-60"))
                            }
                        }.padding(.bottom)
                    }).padding(.vertical, 40).padding(.horizontal, 30)
                }).padding(.bottom)
                PipelineView(pipelines: pipelines)
            }).foregroundColor(Color.white).padding()
        }.padding(.bottom)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
