import SwiftUI

struct CircularButton: View {
    public var isEnabled: Bool
    public var imageName: String
    public var size: CGFloat
    
    public var perform: () -> Void
    
    var body: some View {
        Button {
            perform()
        } label: {
            ZStack {
                Circle()
                    .fill(isEnabled ? .white : Color("MIDarkGray"))
                    .shadow(radius: 1, x: 0, y: 1)
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: size * 0.6)
            }
        }
        .disabled(!isEnabled)
        .frame(width: size, height: size)
    }
}

struct CircularButton_Previews: PreviewProvider {
    static var previews: some View {
        CircularButton(isEnabled: true, imageName: "mic_idle", size: 56) { }
    }
}
