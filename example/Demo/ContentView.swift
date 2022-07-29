//
//  ContentView.swift
//  demoapp
//
//  Created by Jonas Curth on 27.07.22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var recognition = RecognitionCore()
    @State var shouldOpenOptions: Bool = false
    
    private func toggleRecognition() {
        if (recognition.isRecording) {
            recognition.stop()
        }
        else {
            recognition.start()
        }
    }
    
    private func openOptions() {
        self.shouldOpenOptions.toggle()
    }
    
    var body: some View {
        VStack {
            HStack {
                ConnectionStateLabel(state: recognition.state)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                OptionsButton(perform: openOptions)
                    .sheet(isPresented: $shouldOpenOptions) {
                        OptionsView()
                            .environmentObject(recognition)
                    }
            }
            ScrollableText(text: recognition.result)
            
            Spacer()
            
            if (nil != recognition.error) {
                Text(recognition.error!)
                    .foregroundColor(.red)
            }
            
            RecordButton(perform: toggleRecognition)
        }
        .padding()
        .onAppear {
            recognition.initialize()
        }
        .onDisappear {
            recognition.cleanup()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
