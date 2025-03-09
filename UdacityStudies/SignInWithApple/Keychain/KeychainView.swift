import SwiftUI
import KeychainSwift

// Keychain is similiar to UserDefault or AppStorage
// Keychain is encrypted
// Keychain is good for: passwords, social security numbers, credit card infos, sensitive data
// Keychain persists between installs and across devices


struct KeychainView: View {
    let keychain = KeychainSwift()
    @State private var userPassword: String = ""

    var body: some View {
        Button(userPassword.isEmpty ? "No password:" : userPassword) {
            keychain.set("abc123", forKey: "userPassword")

        }
        .onAppear() {
            userPassword = keychain.get("userPassword") ?? ""
        }
    }
}

#Preview {
    KeychainView()
}
