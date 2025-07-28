import SwiftUI
import WebKit
import miSpeechKit

struct LoginView: View {
    @State var user = ""
    @State var password: String = ""
    @State var showPassword = false
    @State var isAuthenticated = false
    @State var errorMessage = ""
    @State var isShowingWebView: Bool = false
    
    @StateObject var recognition = RecognitionCore()
    
    @MainActor
    func authenticate() async throws {
        do {
            let success = try await recognition.authenticate(username: user, password: password)
            
            if (success) {
                Configuration.singleton.login(user: user, password: password)
                isAuthenticated = true
            }
            else {
                errorMessage = "Anmeldung fehlgeschlagen"
            }
        }
        catch let error as MISpeechError {
            switch(error) {
            //case .http(let message, _, _, _):
            //    errorMessage = message
            default:
                errorMessage = "Ein unbekannter Fehler ist aufgetreten"
            }
        }
        catch {
            errorMessage = "Anmeldung fehlgeschlagen: \(error.localizedDescription)"
        }
    }
    
    func load() {
        Configuration.singleton.load()
        if !Configuration.singleton.user.isEmpty {
            self.user = Configuration.singleton.user
            self.password = Configuration.singleton.password
            
            Task { try await self.authenticate() }
        }
    }
    
    var body: some View {
        return ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack() {
                NavigationLink(destination: SpeechView().environmentObject(recognition), isActive: $isAuthenticated) { EmptyView() }
                
                Text("Authentication").font(.title)
                
                LoginForm(user: $user, password: $password)
                
                Button {
                    Task { try await self.authenticate() }
                } label: {
                    Text("Login")
                }

                
                if !errorMessage.isEmpty {
                    Text(errorMessage).foregroundColor(Color("MIRed"))
                }
                
                Text("No MIRA account yet? Register on our website or contact our service for a test account.")
                .padding()
            }
        }
        .onAppear(perform: load)
        .navigationBarBackButtonHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
