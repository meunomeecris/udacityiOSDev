//
//  SignInView.swift
//  UdacityStudies
//
//  Created by Cris Messias on 04/03/25.
//

import SwiftUI
import AuthenticationServices
import Security


struct SignInView: View {
    @Binding var isSignedIn: Bool

    @State private var userIdentifier: String?
    @State var userFullName: String?
    @State var email: String?

    private let appleUserID: String = "appleUserID"

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
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)

            Spacer()

            SignInWithAppleButton(.signIn, onRequest: configureRequest, onCompletion: handleCompletion)
                .signInWithAppleButtonStyle(.black)
                .frame(height: 45)
                .padding()
                .onAppear {
                    loadUserIdentifier()
                }
        }
        .padding()
        .containerRelativeFrame([.horizontal, .vertical])
        .background(Gradient(colors: [.teal, .cyan, .blue]).opacity(0.8))
    }

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
        guard let appleIDCredential = result.credential as? ASAuthorizationAppleIDCredential else { return }

        let userIdentifier = appleIDCredential.user
        let fullName = appleIDCredential.fullName
        let email = appleIDCredential.email

        print("User ID: \(userIdentifier)")
        print("FullName: \(String(describing: userFullName))")
        print("Email: \(String(describing: email))")

        // Salvar User ID no Keychain
        KeychainHelper.shared.save(key: appleUserID, data: userIdentifier.data(using: .utf8)!)

        // Atualizar estado no SwiftUI
        self.userIdentifier = userIdentifier
        self.email = email
        self.userFullName = "\(fullName?.givenName ?? "") \(fullName?.familyName ?? "")"
        self.isSignedIn = true

    }

    private func loadUserIdentifier() {
        if let savedData = KeychainHelper.shared.retrieve(key: appleUserID),
           let savedUserID = String(data: savedData, encoding: .utf8) {
            self.userIdentifier = savedUserID
            self.isSignedIn = true
        }
    }
}


// MARK: - Keychain Helper
class KeychainHelper {
    static let shared = KeychainHelper()

    private init() {}

    func save(key: String, data: Data) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    func retrieve(key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        return status == errSecSuccess ? dataTypeRef as? Data : nil
    }

    func delete(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
