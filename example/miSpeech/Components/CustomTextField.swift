import Foundation
import SwiftUI

struct CustomTextField : UIViewRepresentable {
    public var context: TextContext?
    public var text: Binding<String>
    
    var delegate: TextContextChangedDelegate? = nil
    
    init(text: Binding<String>, delegate: TextContextChangedDelegate? = nil) {
        self.delegate = delegate
        self.text = text
    }
    
    func makeCoordinator() -> CustomTextField.Coordinator {
        Coordinator(self)
    }

    func textContextDidChange(_ context: TextContext) {
        self.delegate?.textContextChanged(context: context)
    }

    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextView {
        let textField = UITextView(frame: .zero)
        
        textField.text = text.wrappedValue
        textField.delegate = context.coordinator
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        self.delegate?.updateTextView(uiView)
        
        uiView.text = text.wrappedValue
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CustomTextField
        var context: TextContext?

        init(_ textField: CustomTextField) {
            self.parent = textField
        }
        
        func textViewDidChangeSelection(_ textField: UITextView) {
            let range = textField.selectedTextRange
            if (nil != range) {
                let startSelection = textField.offset(from: textField.beginningOfDocument, to: range!.start)
                let endSelection = textField.offset(from: textField.beginningOfDocument, to: range!.end)
                
                var previouseText, followingText: String?
                if (nil != textField.text) {
                    let str = textField.text!
                    previouseText = String(str[..<str.index(str.startIndex, offsetBy: startSelection)])
                    followingText = String(str[str.index(str.startIndex, offsetBy: endSelection)...])
                }
                
                self.context = TextContext(previouseText, followingText)
                self.parent.textContextDidChange(self.context!)
            }
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text.wrappedValue = textView.text
        }
    }
}
