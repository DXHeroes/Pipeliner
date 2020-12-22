//
//  DxLabel.swift
//  Pipeliner
//
//  Created by dx hero on 21.12.2020.
//

import Foundation
import SwiftUI

struct DxLabel: View {
    public let text: String
    
    var body: some View {
        Text(text.uppercased()).font(.system(size: 12)).bold().foregroundColor(Color("white-60"))
    }
}

