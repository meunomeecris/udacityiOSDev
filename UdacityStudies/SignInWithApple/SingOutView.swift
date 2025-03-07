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
            
            Text("\(userFullName ?? "John Doe"), \n Welcome to my Udacity Studies!")
                .bold()
                .font(.title)
                .multilineTextAlignment(.center)

            Text("Email: \(email ?? "JohnDoe@example.com")")
                .font(.headline)
                .multilineTextAlignment(.leading)

            Text("User ID: \(userIdentifier ?? "Apple Best User")")
                .font(.headline)
                .multilineTextAlignment(.leading)


            Spacer()

            Button("Sign Out", systemImage:"x.circle") {
                signOut()
                print("User is sign out")
            }
            .padding()
            .foregroundStyle(.white)
            .background(.black)
        }
        .padding()
    }

    private func signOut() {
        KeychainHelper.shared.delete(key: "appleUserID")
        self.userIdentifier = nil
        self.isSignedIn = false
    }
}
