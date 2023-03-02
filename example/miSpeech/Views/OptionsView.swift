import SwiftUI

struct OptionsView: View {
    @EnvironmentObject private var recognition: RecognitionCore
    
    @State private var vocabulary: String = ""
    @State private var config = Configuration.singleton
    @State var isLoggedOut = false
    
    @State var selectedLanguage = "de"
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                NavigationLink(destination: LoginView(), isActive: $isLoggedOut) { EmptyView() }
                
                TextField("Wortschatz", text: $config.vocabulary)
                
                Menu("Sprache auswählen") {
                    Picker("Sprache auswählen", selection: $selectedLanguage) {
                        Text("Deutsch").tag("de")
                        Text("Französisch").tag("fr")
                        Text("Englisch").tag("en")
                    }
                }
                Spacer()
                Button {
                    Task { try await self.recognition.cleanup() }
                    Configuration.singleton.logout()
                    isLoggedOut = true
                } label: {
                    Text("Abmelden")
                }
            }
            .padding()
        }
        .onAppear {
            selectedLanguage = config.language
        }
        .navigationTitle("Einstellungen")
        .toolbar {
            Button("Speichern") {
                config.language = selectedLanguage
                config.save()
                presentationMode.wrappedValue.dismiss()
                
                Task {
                    try await self.recognition.cleanup()
                    try await self.recognition.initialize()
                }
            }
        }
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView().environmentObject(RecognitionCore())
    }
}
