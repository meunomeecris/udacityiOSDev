//
//  SignOut.swift
//  UdacityStudies
//
//  Created by Cris Messias on 07/03/25.
//

import SwiftUI

struct SingOutView: View {
    @Binding var isSignedIn: Bool
    @State var userIdentifier: String?
    @State var userFullName: String?
    @State var email: String?

    var body: some View {
        VStack(spacing: 16) {
            Image("SingInApple")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .padding(.top, 50)
            
            Text("\(userFullName ?? "Cris Messias"), \n Welcome to my Udacity Studies!")
                .bold()
                .font(.title)
                .multilineTextAlignment(.center)

            Text("Email: \(email ?? "meunomeecriss@gmail.com")")
                .font(.headline)
                .multilineTextAlignment(.leading)

            Text("User ID: \(userIdentifier ?? "123456789")")
                .font(.headline)
                .multilineTextAlignment(.leading)

            Spacer()

            Button("Sign Out", systemImage:"x.circle") {
                signOut()
                print("User is sign out")
            }
            .padding()
            .foregroundStyle(.black)
            .background(.white)
        }
        .padding()
    }

    private func signOut() {
        KeychainHelper.shared.delete(key: "appleUserID")
        self.userIdentifier = nil
        self.isSignedIn = false
    }
}
