import Foundation
import KeychainSwift

class Configuration : ObservableObject {
    @Published public var user: String = ""
    @Published public var password: String = ""
    @Published public var language: String = ""
    
    static var singleton: Configuration = Configuration()
    
    let keychain: KeychainSwift
    
    init() {
        self.keychain = KeychainSwift()
    }
    
    func load() {
        self.user = keychain.get("user") ?? ""
        self.password = keychain.get("password") ?? ""
        self.language = keychain.get("language") ?? ""
    }
    
    func save() {
        keychain.set(user, forKey: "user")
        keychain.set(password, forKey: "password")
        keychain.set(language, forKey: "language")
    }
    
    func login(user: String, password: String) {
        self.user = user
        self.password = password
        
        if !keychain.set(user, forKey: "user") {
            let error = SecCopyErrorMessageString(keychain.lastResultCode, nil)
            print(error ?? "")
        }
        
        keychain.set(password, forKey: "password")
    }
    
    func logout() {
        self.user = ""
        self.password = ""
        self.language = ""
        
        keychain.clear()
    }
}
    
