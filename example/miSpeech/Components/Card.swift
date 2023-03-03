import SwiftUI

struct Card<Content: View>: View {
    @ViewBuilder var content: Content
    var isEnabled: Bool = true
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(isEnabled ? Color.white : Color("MIDarkGray"))
                .shadow(radius: 1, x: 0, y: 1)
            
            content
        }
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        Card(content: {}, isEnabled: true)
    }
}
