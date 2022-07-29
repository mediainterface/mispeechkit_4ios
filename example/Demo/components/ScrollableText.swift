//
//  ScrollableText.swift
//  demoapp
//
//  Created by Jonas Curth on 27.07.22.
//

import SwiftUI

struct ScrollableText: View {
    private var text: String
    
    init(text: String){
        self.text = text
    }
    
    var body: some View {
        return GeometryReader { geometry in
            ScrollView {
                Text(text)
                    .textSelection(.enabled)
                    .lineLimit(nil)
                    .frame(width: geometry.size.width)
            }
        }
    }
}

struct ScrollableText_Previews: PreviewProvider {
    static var previews: some View {
        ScrollableText(text: "test")
    }
}
