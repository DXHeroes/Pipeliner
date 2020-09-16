//
//  ConfigurationListView.swift
//  Pipeliner
//
//  Created by dx hero on 07.09.2020.
//

import SwiftUI

struct ConfigurationListView: View {
    public var configurations: [Config]

    var body: some View {
        VStack {
            ForEach(configurations, id: \.self){ index in
                ConfigurationDetailView(configuration: index)
            }.onDelete(perform: delete)

        }.padding(.bottom)    }
}
func delete(at offsets: IndexSet) {
     print("DELETE")
 }

struct ConfigurationListView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationListView(configurations: [Config(id: UUID().uuidString, baseUrl: "https://git.applifting.cz/", projectId: "275", token: "FqWZnzkPBXrdhzfPPJRL", repositoryName: "Cool Project")])
    }
}
