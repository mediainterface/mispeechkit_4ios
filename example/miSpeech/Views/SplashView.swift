import SwiftUI

struct SplashView: View {
    
    @State var isLoggedIn: Bool?
    
    var recognition = RecognitionCore()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image("Clouds")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .rotationEffect(Angle(degrees: 180))
            }
            
            Spacer()
            
            Image("Title")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
            ProgressView()
                .tint(Color("MIBlue"))
            
            Spacer()
            
            HStack {
                Image("Clouds")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Spacer()
            }
        }
        .ignoresSafeArea(.all, edges: .all)
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
