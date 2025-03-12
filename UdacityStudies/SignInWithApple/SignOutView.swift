import SwiftUI
import KeychainSwift

struct SignOutView: View {
    let keychain = KeychainSwift()
    @AppStorage("isSignedIn") var isSignedIn = false

    @State private var userIdentifier: String? = KeychainSwift().get("appleUserID")
    @State private var userFullName: String?
    @State private var email: String?

    private func signOut() {
        keychain.clear()
        isSignedIn = false
        print("User signed out")
    }

    var body: some View {
        VStack(spacing: 16) {
            Image("SingInApple")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .padding(.top, 50)
            
            Text("\(userFullName ?? "User"), \n Welcome to my Udacity Studies!")
                .bold()
                .font(.title)
                .multilineTextAlignment(.center)

            VStack(alignment:.leading ) {
                Text("Email: \(email ?? "email")")
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                
                Text("User ID: \(userIdentifier ?? "ID not found")")
                    .font(.headline)
                    .multilineTextAlignment(.leading)
            }

            Spacer()

            Button("Sign Out", systemImage:"x.circle") {
                signOut()
            }
            .padding()
            .foregroundStyle(.black)
            .background(.white)
        }
        .padding()
    }
}
