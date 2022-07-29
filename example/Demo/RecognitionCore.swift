//
//  RecognitionDelegate.swift
//  demoapp
//
//  Created by Jonas Curth on 27.07.22.
//

import Foundation
import iOSSDK

class RecognitionCore: ObservableObject, IRecognitionDelegate {
    private var recognition: IRecognition?
    
    @Published public var config: Configuration
    
    @Published private(set) var result: String = ""
    @Published private(set) var state: SessionState = SessionState.closed
    @Published private(set) var error: String? = nil
    @Published private(set) var isRecording: Bool = false
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "UserConfig") {
            if let decoded = try? JSONDecoder().decode(Configuration.self, from: data) {
                self.config = decoded
                return
            }
        }
        
        self.config = Configuration()
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(self.config) {
            UserDefaults.standard.set(encoded, forKey: "UserConfig")
        }
    }
    
    internal func onStateChanged(state: SessionState) {
        DispatchQueue.main.async {
            self.state = state
        }
    }
    
    internal func onError(error: String) {
        DispatchQueue.main.async {
            self.error = error
        }
    }
    
    internal func onResult(result: String) {
        DispatchQueue.main.async {
            self.result += result
        }
    }
    
    internal func setRecordingState(isRecording: Bool) {
        DispatchQueue.main.async {
            self.isRecording = isRecording
        }
    }
    
    public func initialize() {
        self.state = .closed
        self.error = nil
        self.result = ""
        self.isRecording = false
        
        let context = AuthenticationContext(system: self.config.system, user: self.config.user, password: self.config.password)
        SpeaKING.getRecognition(self.config.server, context: context, delegate: self) { recognition, error in
            if (nil != error) {
                self.onError(error: error!.errorMessage)
            }
            else {
                self.recognition = recognition
                let recognitionContext = RecognitionContext(user: self.config.user, vocabulary: self.config.vocabulary)
                self.recognition?.initialize(recognitionContext, completion: { _ in })
            }
        }
    }
    
    public func start() {
        if nil != self.recognition {
            self.recognition?.start(previousText: "", followingText: "", completion: { success in
                if(success) {
                    self.setRecordingState(isRecording: true)
                }
            })
        }
    }
    
    public func stop() {
        if nil != self.recognition {
            self.recognition?.stop(completion: { success in
                if(success) {
                    self.setRecordingState(isRecording: false)
                }
            })
        }
    }
    
    public func cleanup() {
        if nil != self.recognition {
            self.recognition?.cleanup(completion: { success in
                self.setRecordingState(isRecording: false)
            })
        }
    }
}
