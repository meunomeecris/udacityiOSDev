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

        

        // Salvar user infos in Keychain
        KeychainHelper.shared.save(key: userIDKey, data: userIdentifier.data(using: .utf8)!)

        if let email = email {
            KeychainHelper.shared.save(key: userEmailKey, data: email.data(using: .utf8)!)
        }

        if !fullNameString.trimmingCharacters(in: .whitespaces).isEmpty {
            KeychainHelper.shared.save(key: userFullNameKey, data: fullNameString.data(using: .utf8)!)
        }

        // Update state
        self.userIdentifier = userIdentifier
        self.email = email
        self.userFullName = fullNameString
        self.isSignedIn = true

    }

    private func loadUserIdentifier() {
        if let savedData = KeychainHelper.shared.retrieve(key: userIDKey),
           let savedUserID = String(data: savedData, encoding: .utf8) {
            print("UserID from Keychain: \(String(describing: savedUserID))")
            self.userIdentifier = savedUserID
            self.isSignedIn = true
        }

        if let savedFullNameData = KeychainHelper.shared.retrieve(key: userFullNameKey),
           let savedFullName = String(data: savedFullNameData, encoding: .utf8) {
            print("FullName from Keychain: \(String(describing: savedFullName))")
            self.userFullName = savedFullName
        }

        if let savedEmailData = KeychainHelper.shared.retrieve(key: userEmailKey),
           let savedEmail = String(data: savedEmailData, encoding: .utf8) {
            print("Email from Keychain: \(savedEmail)")
            self.email = savedEmail
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
