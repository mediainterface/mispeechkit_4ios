import SwiftUI

struct OptionsView: View {
    @EnvironmentObject private var recognition: RecognitionCore
    
    @State private var vocabulary: String = ""
    @State private var config = Configuration.singleton
    @State var isLoggedOut = false
    
    @State var selectedLanguage = "de"
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        NavigationLink(destination: LoginView(), isActive: $isLoggedOut) { EmptyView() }
        Form {
            Section("Language") {
                Picker("Select a language", selection: $selectedLanguage) {
                    Text("German").tag("de")
                    Text("French").tag("fr")
                    Text("English").tag("en")
                }
            }

            Section(footer: HStack {
                Spacer()
                LoginButton(title: "Logout") {
                    Configuration.singleton.logout()
                    isLoggedOut = true
                }
                Spacer()
            }) {
                EmptyView()
            }
        }
        .onAppear {
            selectedLanguage = config.language
        }
        .navigationTitle("Settings")
        .toolbar {
            Button("Save") {
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
