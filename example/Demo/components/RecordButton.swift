//
//  RecordButton.swift
//  demoapp
//
//  Created by Jonas Curth on 27.07.22.
//

import SwiftUI

struct RecordButton: View {
    public var perform: () -> Void
    
    var body: some View {
        Button {
            perform()
        } label: {
            Image(systemName: "mic")
                .resizable()
                .frame(width: 28, height: 40)
                .foregroundColor(Color.white)
        }
        .frame(width: 48, height: 48)
        .background(Color.red)
        .cornerRadius(15)
    }
}

struct RecordButton_Previews: PreviewProvider {
    static var previews: some View {
        RecordButton {
            
        }
    }
}
