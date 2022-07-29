//
//  OptionsButton.swift
//  demoapp
//
//  Created by Jonas Curth on 27.07.22.
//

import SwiftUI

struct OptionsButton: View {
    public var perform: () -> Void
    
    var body: some View {
        Button {
            perform()
        } label : {
            Image(systemName: "gearshape")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(Color.white)
        }
        .frame(width: 32, height: 32)
        .background(.gray)
        .cornerRadius(10)

    }
}

struct OptionsButton_Previews: PreviewProvider {
    static var previews: some View {
        OptionsButton {
            
        }
    }
}
