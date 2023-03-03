import SwiftUI

struct BorderedTextField: View {
    var title: String
    var text: Binding<String>
    
    private var isSecure: Bool
    
    init(_ title: String, text: Binding<String>, isSecure: Bool = false) {
        self.title = title
        self.text = text
        self.isSecure = isSecure
    }
    
    var body: some View {
        VStack {
            if (isSecure) { SecureField(title, text: text) }
            else { TextField(title, text: text) }
        }
        .padding(.all, 5)
        .overlay(RoundedRectangle(cornerRadius: 5).strokeBorder(Color("MIBlue"), style: StrokeStyle(lineWidth: 1.0)))
        
    }
}

struct BorderedTextField_Previews: PreviewProvider {
    static var previews: some View {
        BorderedTextField("", text: .constant(""))
    }
}
