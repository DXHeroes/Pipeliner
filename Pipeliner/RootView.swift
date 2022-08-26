//
//  RootView.swift
//  Pipeliner
//
//  Created by dx hero on 03.09.2020.
//

import SwiftUI
import WidgetKit

struct RootView: View {

    @StateObject var viewModel = RootViewViewModel()
    private let pipelinerService: PipelinerService = PipelinerService()

    @Environment(\.colorScheme) var colorScheme
    @State private var addErrorModal = false
    @State private var addErrorInfo = ""
    @State private var removeErrorModal = false
    @State private var removeErrorInfo = ""

    var body: some View {

        ZStack(alignment: .top) {
            Colors.darkblue
            VStack(alignment: .leading) {
                Link(destination: URL(string: "https://dxheroes.io")!) {
                    Images.DXLogos.green
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                }
                .padding([.horizontal, .top])
                .onHover { inside in
                    inside ? NSCursor.pointingHand.push() : NSCursor.pop()
                }
                HStack(alignment: .top) {
                    VStack {
                        AddConfigurationView(onAdd: { baseUrl, token, projectId, serviceType in
                            Task.init {
                                do {
                                    try await viewModel.loadData(
                                        serviceType,
                                        baseUrl: baseUrl,
                                        projectId: projectId,
                                        token: token
                                    )
                                    WidgetCenter.shared.reloadAllTimelines()
                                }
                                catch let error as HTTPError {
                                    addErrorInfo = error.localizedDescription
                                    addErrorModal.toggle()
                                }
                                catch let error {
                                    print(error)
                                    addErrorInfo = error.localizedDescription
                                    addErrorModal.toggle()
                                }
                            }
                            
                        })
                        .alert(isPresented: $addErrorModal) {
                            Alert(title: Text("There was an error"),
                                  message: Text(addErrorInfo),
                                  dismissButton: .default(Text("OK")))
                        }
                        .padding(.bottom, 40)
                        ScrollView {
                            VStack {
                                Text("Configurations")
                                    .font(.largeTitle)
                                    .foregroundColor(Colors.white60)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                if (viewModel.configurations.count != 0) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text("name".uppercased())
                                                .font(.system(size: 12))
                                                .foregroundColor(Colors.white60)
                                        }
                                        Spacer()
                                        VStack(alignment: .leading) {
                                                Text("remove".uppercased())
                                                .font(.system(size: 12))
                                                .foregroundColor(Colors.white60)
                                        }
                                    }
                                    .padding(.horizontal)
                                    ForEach(viewModel.configurations.indices, id: \.self){ index in
                                        HStack {
                                            Image( nsImage: viewModel.configurations[index].serviceType.serviceIcon())
                                            VStack(alignment: .leading, content: {
                                                Text(viewModel.configurations[index].repositoryName.uppercased())
                                                Text(viewModel.configurations[index].baseUrl).foregroundColor(.gray)
                                            })
                                            Spacer()
                                            VStack(alignment: .leading) {
                                                DxButton(label: "remove", action: {
                                                    Task.init {
                                                        do {
                                                            viewModel.configurations = ConfigurationService.deleteConfiguration(id: viewModel.configurations[index].id)
                                                            try await viewModel.reloadPipelines()
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
                                                    }
                                                }, color: Colors.error, shadow: false)
                                            }
                                        }
                                        .foregroundColor(Color.white)
                                        .padding(.horizontal)
                                        .padding([.vertical], index % 2 == 0 ? 8 : 0)
                                        .background(index % 2 == 0 ? Colors.white4 : Colors.purple)
                                    }
                                } else {
                                    Text("There are no data")
                                        .font(.system(size: 18))
                                        .foregroundColor(Colors.white60)
                                }
                            }
                            .padding(.bottom)
                            .background(Colors.purple)
                            .alert(isPresented: $removeErrorModal) {
                                Alert(title: Text("There was an error"),
                                      message: Text(removeErrorInfo),
                                      dismissButton: .default(Text("OK")))
                            }
                        }
                    }
                    .padding(.trailing, 40)
                    .frame(minWidth: 300)
                    PipelineView(pipelines: viewModel.pipelines)
                        .frame(minWidth: 500)
                }
                .padding()
            }
            .padding()
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
