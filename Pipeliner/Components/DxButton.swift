//
//  DxButton.swift
//  Pipeliner
//
//  Created by dx hero on 18.12.2020.
//

import Foundation
import SwiftUI


private struct DxButtonStyle: ButtonStyle {
    public let bgColor: Color
    public let shadow: Bool
        
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            .background(
                ZStack {
                    if(shadow) {
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                    }
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(bgColor)
                }
            )
            .foregroundColor(.white)
            .animation(.spring())
    }
}

struct DxButton: View {
    public let label: String
    public let action: () -> Void
    public let color: Color
    public let shadow: Bool
    
    var body: some View {
        Button(action: action) {
            Text(label.uppercased()).font(.system(size: 14))
        }.buttonStyle(DxButtonStyle(bgColor: color, shadow: shadow))
        .onHover { inside in
                    if inside {
                        NSCursor.pointingHand.push()
                    } else {
                        NSCursor.pop()
                    }
                }
    }
}
