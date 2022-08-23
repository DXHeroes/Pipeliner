//
//  AddConfigurationView.swift
//  Pipeliner
//
//  Created by dx hero on 21.12.2020.
//

import SwiftUI

struct AddConfigurationView: View {

    @State private var projectId = ""
    @State private var token = ""
    @State private var baseUrl = ""
    @State private var serviceType: ServiceType = .GITLAB
    let allServices = ServiceType.allCases

    @Namespace var animation

    public let onAdd: (_ baseUrl: String, _ token: String, _ projectId: String, _ serviceType: ServiceType) -> Void

    var body: some View {

        VStack {
            Text("Add configuration")
                .font(.largeTitle)
                .foregroundColor(Color("white-60"))
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack(spacing: 24) {
                HStack {
                    DxLabel(text: "service")
                    Picker("", selection: $serviceType.animation()) {
                        ForEach(allServices, id: \.self) { allServices in
                            HStack {
                                Image(nsImage: allServices.serviceIcon())
                                Text(allServices.serviceName())
                            }
                            .tag(allServices)
                        }
                    }
                    .pickerStyle(DefaultPickerStyle())
                    .padding(.init(top: 8, leading: 0, bottom: 8, trailing: 0))
                    .environment(\.colorScheme, .dark)
                }
                VStack(alignment: .leading) {
                    HStack {
                        DxLabel(text: "Web Address")
                        Link(destination: serviceType.webDescriptionLink()) {
                            Image(systemName: "questionmark.circle")
                                .font(.title2)
                                .foregroundColor(.blue)
                                .help("Where your repository is hosted.")
                        }
                        .onHover { inside in
                            inside ? NSCursor.pointingHand.push() : NSCursor.pop()
                        }
                    }
                    DxTextField(
                        value: $baseUrl,
                        placeholder: serviceType.urlPlaceholder(),
                        animation: animation
                    )
                }
                if serviceType != .GITHUB {
                    VStack(alignment: .leading) {
                        DxLabel(text: "Project Id")
                        DxTextField(
                            value: $projectId,
                            placeholder: "1234",
                            animation: animation
                        )
                    }
                }
                VStack(alignment: .leading) {
                    HStack {
                        DxLabel(text: "Private Access Token")
                        Link(destination: serviceType.tokenDescriptionLink()) {
                            Image(systemName: "questionmark.circle")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                        .onHover { inside in
                            inside ? NSCursor.pointingHand.push() : NSCursor.pop()
                        }
                    }
                    DxTextField(
                        value: $token,
                        placeholder: "your-secret-token",
                        animation: animation
                    )
                }
            }
            .padding(.vertical)
            DxButton(
                label: "Add Configuration",
                action: { self.onAdd(baseUrl, token, projectId, serviceType) },
                color: Color("blue"),
                shadow: true
            )
            .padding(.vertical)
            .disabled(!self.isFormValid())
        }
        .padding()
        .background(Color("purple"))

    }
}

private extension AddConfigurationView {
    func isFormValid() -> Bool {
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
}
