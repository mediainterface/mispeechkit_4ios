import SwiftUI

struct LoginView: View {
    @State var user = ""
    @State var password: String = ""
    @State var showPassword = false
    @State var isAuthenticated = false
    @State var errorMessage = ""
    
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
                
                Text("Anmeldung").font(.title)
                
                LoginForm(user: $user, password: $password)
                
                if !errorMessage.isEmpty {
                    Text(errorMessage).foregroundColor(Color("MIRed"))
                }
                
                LoginButton(title: "Anmelden", perform: {
                    Task { try await self.authenticate() }
                }, isEnabled: !user.isEmpty && !password.isEmpty)
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
