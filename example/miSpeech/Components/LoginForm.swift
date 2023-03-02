import SwiftUI

private enum Field: Int, Hashable {
    case user, password
}

struct LoginForm: View {
    @Binding var user: String
    @Binding var password: String
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        Card(content: {
            VStack {
                HStack(alignment: .center) {
                    Spacer()
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: 50, height: 50, alignment: .center)
                        .foregroundColor(Color("MIBlue"))
                    Spacer()
                }.padding(.bottom, 10)
                
                BorderedTextField("Nutzer", text: $user)
                    .focused($focusedField, equals: .user)
                
                BorderedTextField("Passwort", text: $password, isSecure: true)
                    .focused($focusedField, equals: .password)
            }
            .padding()
        })
        .frame(height: 150)
        .padding()
    }
}

struct LoginForm_Previews: PreviewProvider {
    static var previews: some View {
        LoginForm(user: .constant(""), password: .constant(""))
    }
}
