//
//  SignInWithApple.swift
//  UdacityStudies
//
//  Created by Cris Messias on 07/03/25.
//

import SwiftUI
import AuthenticationServices

struct SignInWithApple: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("email") var email = ""
    @AppStorage("firstName") var firstName = ""
    @AppStorage("lastName") var lastName = ""
    @AppStorage("userIdentifier") var userIdentifier = ""


    var body: some View {
        NavigationView {
            VStack {
                SignInWithAppleButton(.signIn) { request in
                    
                    request.requestedScopes = [.email, .fullName]
                    
                } onCompletion: { result in
                    switch result {
                    case .success(let auth):
                        handleAuthSuccess(auth)

                    case .failure(let error):
                        print("Authorization failed: \(error.localizedDescription)")
                    }
                }
                .signInWithAppleButtonStyle(
                    colorScheme == .dark ? .white : .black
                )
                .frame(height: 50)
                .padding()
            }
            .navigationTitle("Sign in")
        }
    }

    private func handleAuthSuccess(_ result: ASAuthorization) {
        guard let credential = result.credential as? ASAuthorizationAppleIDCredential else { return }

        let userIdentifier = credential.user

        let email = credential.email
        let firstName = credential.fullName?.givenName
        let lastName = credential.fullName?.familyName



        print("User Identifier: \(userIdentifier)")
        print("Email: \(String(describing: email))")
        print("Full Name: \(String(describing: firstName)) \(String(describing: lastName))")

        self.userIdentifier = userIdentifier
        self.email = email ?? "johndoe@example.com"
        self.firstName = firstName ?? "Jhon"
        self.lastName = lastName ?? "Doe"

    }
}
