//
//  AddConfigurationView.swift
//  Pipeliner
//
//  Created by dx hero on 21.12.2020.
//

import SwiftUI

struct AddConfigurationView: View {
    @Namespace var animation
    @State private var projectId = ""
    @State private var token = ""
    @State private var baseUrl = ""
    @State private var serviceType: ServiceType = .GITLAB
    @Environment(\.colorScheme) var colorScheme    
    public let onAdd: (_ baseUrl: String, _ token: String, _ projectId: String, _ serviceType: ServiceType) -> Void
    
    
    private func isFormValid() -> Bool {
        // GitHub service doesn't use projectId
        if self.serviceType != .GITHUB && projectId.isEmpty {
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
    let allServices = ServiceType.allCases
    var body: some View {
        VStack {
            Text("Add configuration").font(.system(size: 24)).foregroundColor(Color("white-60")).frame(maxWidth: .infinity, alignment: .topLeading).padding()
            HStack {
                DxLabel(text: "service")
                Picker("", selection: $serviceType.animation()) {
                    ForEach(allServices,id: \.self) { allServices in
                        HStack(content: {
                            Image( nsImage: allServices.serviceIcon())
                            Text(allServices.serviceName())
                        }).tag(allServices)
                    }
                }
                .pickerStyle(DefaultPickerStyle())
                .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                .environment(\.colorScheme, .dark)
            }.padding([.top, .horizontal])
            Form {
                Section{
                    HStack {
                        DxLabel(text: "Web Address")
                        Image(systemName: "questionmark.circle").font(.title2).foregroundColor(.blue)
                            .help("Where your repository is hosted.")
                    }.padding([.top, .leading])
                    DxTextField(value: $baseUrl,placeholder: serviceType.urlPlaceholder(), animation: animation).padding(.horizontal)
                    if serviceType != .GITHUB {
                        DxLabel(text: "Project Id").padding([.top, .leading])
                        DxTextField(value: $projectId,placeholder: "1234", animation: animation).padding(.horizontal)
                    }
                    HStack {
                        DxLabel(text: "Private Access Token")
                        Link(destination: serviceType.tokenDescriptionLink()) {
                            Image(systemName: "questionmark.circle").font(.title2).foregroundColor(.blue)
                        }.onHover { inside in
                            if inside {
                                NSCursor.pointingHand.push()
                            } else {
                                NSCursor.pop()
                            }
                        }
                    }.padding([.top, .leading])
                    DxTextField(value: $token,placeholder: "your-secret-token", animation: animation).padding(.horizontal)
                }
            }
            DxButton(label: "Add Configuration", action:{
                        self.onAdd(baseUrl, token, projectId, serviceType)}, color: Color("blue"), shadow: true).disabled(!self.isFormValid()).padding()
        }.background(Color("purple"))
    }
}
