//
//  RandomUser.swift
//  UdacityStudies
//
//  Created by Cris Messias on 25/02/25.
//

import SwiftUI

struct RandomUser: View {
    var modelData: RandomUserData

    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle")
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.white, lineWidth: 4)
                }
                .frame(width: 100, height: 100)

            Text(modelData.name)
                .font(.title2)
                .padding()

            Text("Email: \(modelData.email) ")
                .font(.body)
                .padding()
        }
        .onAppear { modelData.fetchData() }
    }
}
