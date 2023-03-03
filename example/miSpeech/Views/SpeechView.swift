import SwiftUI

struct SpeechView: View {
    @EnvironmentObject var recognition: RecognitionCore
    @State var shouldOpenOptions: Bool = false
    @State var text: String = ""
    
    @Environment(\.scenePhase) var scenePhase
    
    private func openOptions() {
        self.shouldOpenOptions.toggle()
    }
    
    private func toggleRecord() {
        Task {
            if (recognition.isRecording) { try await recognition.stop() }
            else { try await recognition.start() }
        }
    }
    
    private func getMicrophoneImage() -> String {
        return nil != self.recognition.sessionId
            ? recognition.isRecording
                ? "mic_active"
                : "mic_idle"
            : "mic_disabled"
        
    }
    
    var body: some View {
        let textField = CustomTextField(text: $text, delegate: recognition)
        
        return VStack {
            NavigationLink(destination: OptionsView(), isActive: $shouldOpenOptions) { EmptyView() }
            HStack{
                Text(recognition.preview)
                    .frame(height: 10)
                    .foregroundColor(.gray)
                    .truncationMode(.head)
                    .lineLimit(1)
                Spacer()
            }
            
            Card(content: { textField.padding(3) }, isEnabled: true)
            
            Spacer()
            
            if (nil != recognition.error) {
                Text(recognition.error!)
                    .foregroundColor(.red)
            }
            
            HStack {
                CircularButton(isEnabled: !text.isEmpty, imageName: text.isEmpty ? "copy_disabled" : "copy", size: 56) {
                    UIPasteboard.general.string = $text.wrappedValue
                }
                    .padding(.trailing, 5)
                
                CircularButton(
                    isEnabled: nil != recognition.sessionId,
                    imageName: getMicrophoneImage(),
                    size: 72,
                    perform: toggleRecord)
                
                CircularButton(isEnabled: !text.isEmpty, imageName: text.isEmpty ? "cut_disabled" : "cut", size: 56) {
                    UIPasteboard.general.string = $text.wrappedValue
                    text = ""
                }
                    .padding(.leading, 5)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("miSpeech")
        .padding()
        .onAppear {
            Task {
                try await recognition.initialize()
            }
        }
        .onChange(of: scenePhase) { newValue in
            if newValue == .inactive {
                Task { try await recognition.cleanup() }
            }
            else if newValue == .active {
                Task { try await recognition.initialize() }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                OptionsButton(perform: openOptions)
            }
        }
    }
}

struct SpeechView_Previews: PreviewProvider {
    static var previews: some View {
        SpeechView().environmentObject(RecognitionCore())
    }
}
