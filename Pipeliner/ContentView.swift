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
    let headerText = (dark: Color.gray, light: Color.black)
    let miniIcon = (dark: Color.blue, light: Color.purple)
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
      Color(colorScheme == .dark ? windowBackground.dark: windowBackground.light).opacity(0.15).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        HStack(content: {
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, content: {
              Image(systemName: "gear").font(.system(size: 40)).foregroundColor(colorScheme == .dark ? headerIcon.dark: headerIcon.light).padding(.bottom, 6)
              Text("Add Configuration").font(.title2).multilineTextAlignment(.center).foregroundColor(colorScheme == .dark ? headerText.dark: headerText.light)
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
                        Text("Base Url").font(.title3).padding(.horizontal)
                        TextField(selection.urlPlaceholder(),text: $baseUrl).cornerRadius(5).padding(.horizontal)
                        if selection != .GITHUB {
                            Text("Project ID").padding(.horizontal)
                            TextField("1234",text: $projectId).cornerRadius(5).padding(.horizontal)
                        }
                        HStack {
                            Text("Private Access Token").font(.title3).cornerRadius(15).padding(.leading)
                            Link(destination: selection.tokenDescriptionLink()) {
                              Image(systemName: "questionmark.circle").font(.title3).foregroundColor(colorScheme == .dark ? miniIcon.dark: miniIcon.light)
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
                    Image(systemName: "plus.circle").font(.system(size: 24)).foregroundColor(colorScheme == .dark ? miniIcon.dark: miniIcon.light)
                }.disabled(!self.isFormValid()).padding().buttonStyle(BorderlessButtonStyle())
                VStack {
                    Image(systemName: "square.and.arrow.down.on.square").font(.system(size: 40)).foregroundColor(colorScheme == .dark ? headerIcon.dark: headerIcon.light).padding(.bottom, 6)
                  Text("Saved Configuration").font(.title2).multilineTextAlignment(.center).foregroundColor(colorScheme == .dark ? headerText.dark: headerText.light)
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
                                        Image(systemName: "minus.circle").font(.system(size: 24)).foregroundColor(colorScheme == .dark ? miniIcon.dark: miniIcon.light)
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
                Image(systemName: "waveform.path.ecg").font(.system(size: 40)).foregroundColor(colorScheme == .dark ? headerIcon.dark: headerIcon.light).padding(.bottom, 6)
              Text("Pipelines").font(.title2).multilineTextAlignment(.center).foregroundColor(colorScheme == .dark ? headerText.dark: headerText.light)
                Divider()
                if(pipelines.count != 0) {
                ForEach(0..<pipelines.count){ index in
                    PipelineDetailView(pipeline: pipelines[index], isLastRow: index == pipelines.count - 1 ? true : false)
                }
                    
                }
                Spacer()
            }
            
        }).foregroundColor(colorScheme == .dark ? formTitle.dark: formTitle.light).padding()
        Spacer()
    }.padding(.bottom)
   }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
