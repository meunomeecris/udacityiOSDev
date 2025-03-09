import SwiftUI
import AuthenticationServices
import KeychainSwift


struct SignInView: View {
    let keychain = KeychainSwift()

    @AppStorage("isSignedIn") var isSignedIn = false

    @State var userIdentifier: String?
    @State var userFullName: String?
    @State var email: String?


    private let userIDKey: String = "appleUserID"
    private let userFullNameKey = "appleUserFullName"
    private let userEmailKey = "appleUserEmail"


    private func configureRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }

    private func handleCompletion(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            handleAuthSuccess(authorization)
        case .failure(let error):
            print("Authorization failed: \(error.localizedDescription)")
        }

    }

    private func handleAuthSuccess(_ result: ASAuthorization) {
        guard let credential = result.credential as? ASAuthorizationAppleIDCredential else { return }

        let userIdentifier = credential.user
        let fullName = credential.fullName
        let email = credential.email

        let fullNameString = "\(fullName?.givenName ?? "") \(fullName?.familyName ?? "")"


        print("User ID: \(userIdentifier)")
        print("FullName: \(fullNameString)")
        print("Email: \(email ?? "No Email")")

        

        // Save user infos in Keychain
        keychain.set(userIdentifier.data(using: .utf8)!, forKey: userIDKey)

        if let email = email {
            keychain.set(email, forKey: userEmailKey)
        }

        if !fullNameString.trimmingCharacters(in: .whitespaces).isEmpty {
            keychain.set(fullNameString, forKey: userEmailKey)
        }

        // Update state
        isSignedIn = true

    }

    private func loadUserIdentifier() {

        if let _  = keychain.get(userIDKey) {
            isSignedIn = true
        }
    }

    var body: some View {
        VStack {
            Image("UdacityLogo")
                .resizable()
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                .padding(.top, 50)


            Text("Udacity Studies")
                .bold()
                .font(.title)
                .padding(.top, 16)
                .foregroundStyle(.white)

            Text("Are you curious about what I am learning? Just sign in!")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)

            Spacer()

            LoginView()
                .padding(.bottom, 50)

            SignInWithAppleButton(.signIn, onRequest: configureRequest, onCompletion: handleCompletion)
                .signInWithAppleButtonStyle(.black)
                .frame(height: 45)
                .padding()
        }
        .padding()
        .onAppear {
            loadUserIdentifier()
        }
        .containerRelativeFrame([.horizontal, .vertical])
        .background(Gradient(colors: [.teal, .cyan, .blue]).opacity(0.8))
    }
}
