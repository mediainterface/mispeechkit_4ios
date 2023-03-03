import SwiftUI

struct ContentView: View {
    @StateObject private var recognition = RecognitionCore()
    
    @State private var activeView: String? = nil
    
    func tryLogin() {
        Configuration.singleton.load()
        if !Configuration.singleton.user.isEmpty {
            Task { await self.authenticate() }
        }
        else {
            activeView = NavigationKey.login
        }
    }
    
    func authenticate() async {
        do {
            _ = try await recognition.authenticate(username: Configuration.singleton.user, password: Configuration.singleton.password)
            
            withAnimation { activeView = NavigationKey.speech }
        }
        catch {
            withAnimation { activeView = NavigationKey.login }
            
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: SpeechView(), tag: NavigationKey.speech, selection: $activeView) { EmptyView() }
                NavigationLink(destination: LoginView(), tag: NavigationKey.login, selection: $activeView) { EmptyView() }
                
                SplashView()
                
            }
            .onAppear(perform: tryLogin)
        }
        .navigationViewStyle(.stack)
        .environmentObject(recognition)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct NavigationKey {
    static let login = "login"
    static let speech = "speech"
    static let options = "options"
}
