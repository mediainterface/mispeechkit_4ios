import SwiftUI

struct LoginButton: View {
    var title: String
    var perform: () -> Void
    var isEnabled: Bool = true
    
    var body: some View {
        Button {
            perform()
        } label : {
            Card(content:  {
                HStack {
                    Image(isEnabled ? "logout" : "logout_disabled")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.horizontal, 5)
                    Text(title).foregroundColor(isEnabled ? .black : .white)
                        .padding(.horizontal, 5)
                }.padding(.vertical, 5)
            }, isEnabled: isEnabled)
            .frame(width: 150, height: 32)
        }
        .disabled(!isEnabled)
        
    }
}

struct LoginButton_Previews: PreviewProvider {
    static var previews: some View {
        LoginButton(title: "Anmelden", perform: {}, isEnabled: true)
    }
}
