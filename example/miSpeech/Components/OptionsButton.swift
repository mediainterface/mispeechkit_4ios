import SwiftUI

struct OptionsButton: View {
    public var perform: () -> Void
    
    var body: some View {
        Button {
            perform()
        } label : {
            Image(systemName: "gearshape.fill")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(Color("MIBlue"))
        }
        .frame(width: 32, height: 32)

    }
}

struct OptionsButton_Previews: PreviewProvider {
    static var previews: some View {
        OptionsButton {
            
        }
    }
}
