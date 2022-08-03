//
//  ConnectionState.swift
//  demoapp
//
//  Created by Jonas Curth on 27.07.22.
//

import SwiftUI
import miSpeechKit

struct ConnectionStateLabel: View {
    private var state: SessionState = .closed
    
    init(state: SessionState) {
        self.state = state
    }
    
    var body: some View {
        if .ready == self.state {
            Text("Verbunden")
                .frame(width: 100, height: 25)
                .background(.green)
                .cornerRadius(10)
        }
        else if .loading == self.state {
            Text("Lädt...")
                .frame(width: 100, height: 25)
                .background(.blue)
                .cornerRadius(10)
        }
        else if .inProcess == self.state {
            Text("Aufnahme läuft...")
                .frame(width: 150, height: 25)
                .background(.blue)
                .cornerRadius(10)
        }
        else {
            Text("Getrennt")
                .frame(width: 100, height: 25)
                .background(.red)
                .cornerRadius(10)
        }
    }
}

struct ConnectionStateLabel_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionStateLabel(state: .closed)
    }
}
