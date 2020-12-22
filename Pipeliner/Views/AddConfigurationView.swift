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
    
    var body: some View {
        ZStack(alignment: .top, content: {
            Color("purple")
            VStack {
                Text("Add configuration").font(.system(size: 24)).foregroundColor(Color("white-60")).frame(maxWidth: .infinity, alignment: .topLeading).padding()
                HStack {
                    DxLabel(text: "service")
                    Picker("", selection: $serviceType.animation()) {
                        ForEach(ServiceType.allCases, id: \.self) {
                            Text($0.rawValue).tag($0)
                        }
                    }
                    .pickerStyle(DefaultPickerStyle())
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
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
                            }
                        }.padding([.top, .leading])
                        DxTextField(value: $token,placeholder: "your-secret-token", animation: animation).padding(.horizontal)
                    }
                }
                DxButton(label: "Add Configuration", action:{
                            self.onAdd(baseUrl, token, projectId, serviceType)}, color: Color("blue"), shadow: true).disabled(!self.isFormValid()).padding()
            }
        }).padding(.vertical, 40).padding(.horizontal, 30)    }
}

