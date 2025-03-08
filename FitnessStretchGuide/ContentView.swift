import SwiftUI
import Firebase
import FirebaseAuth

struct ContentView: View {
    @State private var currentUser: User?
    @State private var showSplash = true
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashScreen()
                    .onAppear {
                        checkCurrentUser()
                    }
            } else {
           
                    HomeView()
               
            }
        }
    }
    
    private func checkCurrentUser() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            currentUser = Auth.auth().currentUser
            showSplash = false
        }
    }
}

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Image("image")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // Maximize the space
                    .padding() // Add some padding if needed
                
                Text("Fitness App")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}



