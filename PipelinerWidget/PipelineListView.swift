//
//  PipelineListView.swift
//  PipelinerWidgetExtension
//
//  Created by dx hero on 03.09.2020.
//

import SwiftUI
import WidgetKit

struct PipelineListView: View {

    public var pipelines: [PipelineResult]
    public var size: WidgetFamily

    var body: some View {
        VStack {
            ForEach(0..<pipelines.count){ index in
                PipelineRowView(pipeline: pipelines[index], size: size, isOdd: index % 2 != 0)
            }
        }.padding(.bottom)
    }
}

struct PipelineListView_Previews: PreviewProvider {
    static var previews: some View {
        PipelineListView(pipelines: [], size: WidgetFamily.systemMedium)
    }
}
