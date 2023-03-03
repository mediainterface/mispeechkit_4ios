import Foundation
import miSpeechKit
import SwiftUI

class RecognitionCore: ObservableObject, TextContextChangedDelegate {
    private var recognition: IRecognition?
    
    @Published var state: SessionState = .closed
    @Published private(set) var error: String? = nil
    @Published private(set) var isRecording: Bool = false
    @Published private(set) var sessionId: UUID? = nil
    @Published private(set) var preview: String = ""
    
    public var textField: UITextView?
    
    
    private var context: TextContext? = nil
    
    func updateTextView(_ textView: UITextView) {
        self.textField = textView
    }
    
    func textContextChanged(context: TextContext) {
        self.context = context
    }
    
    internal func onStateChanged(e: StateChangedEventArgs) {
        DispatchQueue.main.async {
            if (nil != e.state) {
                self.state = e.state!
            }
            
            if (self.sessionId != e.sessionId) {
                self.sessionId = e.sessionId
            }
        }
    }
    
    internal func onError(e: ErrorOccuredEventArgs) {
        DispatchQueue.main.async {
            self.error = e.message
        }
    }
    
    internal func onPreview(e: PreviewChangedEventArgs) {
        DispatchQueue.main.async {
            self.preview = e.text
        }
    }
    
    internal func onResult(e: ResultChangedEventArgs) {
        DispatchQueue.main.async {
            let text = e.text.replacingOccurrences(of: "\r\n", with: "\n")
            self.textField?.insertText(text)
        }
    }
    
    internal func onAudioStateChanged(e: AudioStateChangedEventArgs) {
        DispatchQueue.main.async {
            self.isRecording = e.isRecording
        }
    }
    
    @MainActor
    public func authenticate(username: String, password: String?) async throws -> Bool {
        var success = true
        do{
            let context = try MISpeech.createAuthenticationContext(user: username, password: password)
            self.recognition = try await MISpeech.createRecognitionAsync(server: nil, context: context)
            
            self.recognition?.stateChanged.addHandler(handler: onStateChanged)
            self.recognition?.resultChanged.addHandler(handler: onResult)
            self.recognition?.previewChanged.addHandler(handler: onPreview)
            self.recognition?.errorOccured.addHandler(handler: onError)
            self.recognition?.audioStateChanged.addHandler(handler: onAudioStateChanged)
        }
        catch MISpeechError.unauthorized { success = false }
        catch { throw error }
        return success
    }
    
    @MainActor
    public func initialize() async throws {
        let recognitionContext = try MISpeech.createRecognitionContext(user: Configuration.singleton.user, previewResults: true, debug: true, language: Configuration.singleton.language)
        
        do {
            try await self.recognition?.initializeAsync(recognitionContext)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    @MainActor
    public func start() async throws {
        if nil != self.recognition {
            try await self.recognition!.startAsync(previousText: self.context?.previouseText, followingText: self.context?.followingText)
        }
    }
    
    @MainActor
    public func stop() async throws {
        if nil != self.recognition {
            try await self.recognition!.stopAsync()
        }
    }
    
    @MainActor
    public func cleanup() async throws{
        if nil != self.recognition {
            try await self.recognition!.cleanupAsync()
            
            self.state = .closed
            self.error = nil
            self.isRecording = false
        }
    }
}
