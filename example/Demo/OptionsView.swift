//
//  OptionsView.swift
//  demoapp
//
//  Created by Jonas Curth on 27.07.22.
//

import SwiftUI

struct OptionsView: View {
    @State private var server: String = ""
    @State private var system: String = ""
    @State private var user: String = ""
    @State private var password: String = ""
    @State private var vocabulary: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var recognition: RecognitionCore
    
    private func loadData() {
        self.server = self.recognition.config.server
        self.system = self.recognition.config.system
        self.user = self.recognition.config.user
        self.password = self.recognition.config.password
        self.vocabulary = self.recognition.config.vocabulary
    }
    
    private func saveData() {
        self.recognition.config.server = self.server
        self.recognition.config.system = self.system
        self.recognition.config.user = self.user
        self.recognition.config.password = self.password
        self.recognition.config.vocabulary = self.vocabulary
        
        self.recognition.save()
        self.recognition.initialize()
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack {
                VStack(alignment: .trailing) {
                    HStack {
                        Button("Abbrechen") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        Spacer()
                        Button("Speichern") {
                            self.saveData()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                Text("Einstellungen")
                    .font(.title)
                Spacer().frame(maxHeight: 50)
                TextField("Server", text: $server)
                TextField("System", text: $system)
                TextField("Benutzer", text: $user)
                SecureField("Passwort", text: $password)
                TextField("Wortschatz", text: $vocabulary)
                Spacer()
            }
            .padding()
            .onAppear(perform: loadData)
        }
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView()
    }
}
