//
//  DxTextField.swift
//  Pipeliner
//
//  Created by dx hero on 18.12.2020.
//

import Foundation
import SwiftUI

struct DxTextField: View {
    @Binding var value: String
    let placeholder: String
    var animation: Namespace.ID
    
    var body: some View {
        
        VStack(){
            HStack(alignment: .bottom){
                VStack() {
                    ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
                        TextField(placeholder, text: $value)
                            .frame(alignment: .center)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(Color("white-10"))
    }
}

//Disable default texfield border when focused
extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}
