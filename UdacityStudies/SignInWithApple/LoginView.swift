import SwiftUI
import KeychainSwift

struct LoginView: View {
    let keychain = KeychainSwift()

    @AppStorage("isSignedIn") var isSignedIn = false

    @State private var username = ""
    @State private var password = ""
    @State private var errorMessage = ""
    
    func validateInputs() -> Bool {
        return !username.isEmpty && !password.isEmpty && password.count >= 6
    }

    func saveToKeychain() {
        keychain.set(username, forKey: "username")
        keychain.set(password, forKey: "password")

    }

    var body: some View {

        VStack(spacing: 20) {
            TextField("Username", text: $username)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)

            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)

            Button(action: {
                if validateInputs() {
                    saveToKeychain()
                    isSignedIn = true
                } else {
                    errorMessage = "Invalid input"
                }
            }) {
                Text("Login")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(validateInputs() ? Color.black : Color.white.opacity(0.2))
                    .cornerRadius(10)
            }
            .disabled(!validateInputs())

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}
