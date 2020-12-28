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
    @State private var addErrorModal = false
    @State private var addErrorInfo = ""
    @State private var removeErrorModal = false
    @State private var removeErrorInfo = ""    
    init() {
        
        _pipelines = State(initialValue: try! pipelinerService.getPipelines(pipelineCount: 10))
        _configurations = State(initialValue:  ConfigurationService.getConfigurations())
    }
    
    var body: some View {
        ZStack(alignment: .top, content: {
            Color("darkblue")
            HStack(alignment: .top, content: {
                VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, content: {
                    AddConfigurationView(onAdd: { baseUrl, token, projectId, serviceType in
                        do {
                            let config = try pipelinerService.getConfig(
                                serviceType, baseUrl: baseUrl, projectId: projectId, token: token)
                            configurations =  ConfigurationService.addConfiguration(config: config)
                            pipelines = try pipelinerService.getPipelines(pipelineCount: 10)
                            WidgetCenter.shared.reloadAllTimelines()
                        }
                        catch let error as HTTPError {
                            addErrorInfo = error.localizedDescription
                            addErrorModal.toggle()
                        }
                        catch let error {
                            addErrorInfo = error.localizedDescription
                            addErrorModal.toggle()
                        }
                        
                    }).alert(isPresented: $addErrorModal) {
                        Alert(title: Text("There was an error"),
                              message: Text(addErrorInfo),
                              dismissButton: .default(Text("OK")))
                    }.padding(.bottom, 40)
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
                                            do {
                                                configurations = ConfigurationService.deleteConfiguration(id: configurations[index].id)
                                                pipelines = try pipelinerService.getPipelines(pipelineCount: 10)
                                                WidgetCenter.shared.reloadAllTimelines()
                                            }
                                            catch let error as HTTPError {
                                                removeErrorInfo = error.localizedDescription
                                                removeErrorModal.toggle()
                                            }
                                            catch let error {
                                                removeErrorInfo = error.localizedDescription
                                                removeErrorModal.toggle()
                                            }
                                        }, color: Color("error"), shadow: false)
                                    })
                                }).foregroundColor(Color.white).padding(.horizontal)
                                .padding([.vertical], index % 2 == 0 ? 8 : 0).background(index % 2 == 0 ? Color("white-4") : Color("purple"))
                            }
                        } else {
                            Text("There are no data").font(.system(size: 18)).foregroundColor(Color("white-60"))
                        }
                    }.padding(.bottom).background(Color("purple"))
                    .alert(isPresented: $removeErrorModal) {
                        Alert(title: Text("There was an error"),
                              message: Text(removeErrorInfo),
                              dismissButton: .default(Text("OK")))
                    }
                }).padding(.trailing, 40).frame(minWidth: 300)
                PipelineView(pipelines: pipelines).frame(minWidth: 500)
            }).padding()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
