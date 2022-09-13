//
//  Configuration.swift
//  demoapp
//
//  Created by Jonas Curth on 27.07.22.
//

import Foundation

class Configuration : Codable, ObservableObject {
    @Published public var server: String = "demo.mediainterface.de"
    @Published public var system: String = ""
    @Published public var user: String = ""
    @Published public var password: String = ""
    @Published public var vocabulary: String = ""
    
    init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.server = try container.decode(String.self, forKey: .server)
        self.system = try container.decode(String.self, forKey: .system)
        self.user = try container.decode(String.self, forKey: .user)
        self.password = try container.decode(String.self, forKey: .password)
        self.vocabulary = try container.decode(String.self, forKey: .vocabulary)
    }
    
    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(server, forKey: .server)
        try container.encode(system, forKey: .system)
        try container.encode(user, forKey: .user)
        try container.encode(password, forKey: .password)
        try container.encode(vocabulary, forKey: .vocabulary)
    }
    
    enum CodingKeys: CodingKey {
        case server, system, user, password, vocabulary
    }
}
