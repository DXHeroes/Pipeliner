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
    static let serviceTypes = ServiceType.allCases.map { $0.rawValue }
    @State private var serviceType = 0
    @State private var projectId = ""
    @State private var token = ""
    @State private var baseUrl = ""
    @State private var savedBaseUrl = ""
    @State private var pipelines: [PipelineResult]
    @State private var configurations: [Config]
    
    @State private var selection: ServiceType = .GITLAB
    
    @Environment(\.colorScheme) var colorScheme

    let windowBackground = (dark: NSColor.darkGray, light: NSColor.white)
    let headerIcon = (dark: Color.white, light: Color.purple)
    let headerText = Color.gray
    let miniIcon = Color.blue
    let formTitle = (dark: Color.white, light: Color.black)
    let projectTitle = (dark: Color.white, light: Color.black)
    let projectSubtitle = Color.gray

    init() {
        _pipelines = State(initialValue:  pipelinerService.getPipelines(pipelineCount: 10))
        _configurations = State(initialValue:  ConfigurationService.getConfigurations())
    }

    
    private func isFormValid() -> Bool {
        if projectId.isEmpty {
            return false
        }

        if baseUrl.isEmpty {
            return false
        }
        
        if token.isEmpty {
            return false
        }

        return true
    }
   var body: some View {
    ZStack {
        Color(windowBackground.dark).opacity(0.15).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        HStack(content: {
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, content: {
                Image(systemName: "gear").font(.system(size: 40)).foregroundColor(headerIcon.dark)
                Text("Add Configuration").multilineTextAlignment(.center).foregroundColor(headerText)
                Divider()
                Picker("Service", selection: $selection.animation()) {
                    ForEach(ServiceType.allCases, id: \.self) {
                        Text($0.rawValue).tag($0)
                    }
                }
                .pickerStyle(DefaultPickerStyle())
                .padding(.horizontal)
                .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                Form {
                    Section{
                        Text("Base Url").padding(.horizontal)
                        TextField(selection.urlPlaceholder(),text: $baseUrl).cornerRadius(5).padding(.horizontal)
                        if selection != .GITHUB {
                            Text("Project Id").padding(.horizontal)
                            TextField("1234",text: $projectId).cornerRadius(5).padding(.horizontal)
                        }
                        HStack {
                            Text("Private Access Token").cornerRadius(15).padding(.leading)
                            Link(destination: selection.tokenDescriptionLink()) {
                                Image(systemName: "questionmark.circle").font(.title2).foregroundColor(miniIcon)
                            }
                        }
                        TextField("your-secret-token",text: $token).cornerRadius(5).padding(.horizontal)
                    }
                }
                Button(action: {
                    if let projectName = pipelinerService.getProjectName(baseUrl: baseUrl, projectId: projectId, token: token) {
                        configurations =  ConfigurationService.addConfiguration(config: Config(id: UUID().uuidString, baseUrl: baseUrl, projectId: projectId, token: token, repositoryName: projectName))
                        pipelines = pipelinerService.getPipelines(pipelineCount: 10)
                        WidgetCenter.shared.reloadAllTimelines()

                    } else {
                        savedBaseUrl = "not found"
                    }
                }) {
                    Image(systemName: "plus.circle").font(.system(size: 24)).foregroundColor(miniIcon)
                }.disabled(!self.isFormValid()).padding().buttonStyle(BorderlessButtonStyle())
                VStack {
                    Image(systemName: "square.and.arrow.down.on.square").font(.system(size: 40)).foregroundColor(headerIcon.dark)
                    Text("Saved Configuration").multilineTextAlignment(.center).foregroundColor(headerText)
                    Divider()
                    VStack {
                        ForEach(configurations, id: \.self){ configuration in
                            HStack(content: {
                                VStack(alignment: .leading, content: {
                                    Text(configuration.repositoryName.uppercased())
                                  Text(configuration.baseUrl).foregroundColor(projectSubtitle)
                                })
                                Spacer()
                                VStack(alignment: .leading, content: {
                                    Button(action: {
                                        configurations = ConfigurationService.deleteConfiguration(id: configuration.id)
                                        pipelines = pipelinerService.getPipelines(pipelineCount: 10)
                                        WidgetCenter.shared.reloadAllTimelines()
                                    }) {
                                        Image(systemName: "minus.circle").font(.system(size: 24)).foregroundColor(miniIcon)
                                    }
                                })
                            }).foregroundColor(projectTitle.dark).padding(.horizontal).buttonStyle(BorderlessButtonStyle())
                        }
                    }.padding(.bottom)
                }.padding(.bottom)
                Spacer()
            }).padding(.bottom)
            Divider()
            VStack {
                Image(systemName: "waveform.path.ecg").font(.system(size: 40)).foregroundColor(headerIcon.dark)
                Text("Pipelines").multilineTextAlignment(.center).foregroundColor(headerText)
                Divider()
                if(pipelines.count != 0) {
                ForEach(0..<pipelines.count){ index in
                    PipelineDetailView(pipeline: pipelines[index], isLastRow: index == pipelines.count - 1 ? true : false)
                }
                    
                }
                Spacer()
            }
            
        }).foregroundColor(formTitle.dark).padding()
        Spacer()
    }.padding(.bottom)
   }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
