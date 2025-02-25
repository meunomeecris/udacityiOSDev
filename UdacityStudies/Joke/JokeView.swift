//
//  JokeView.swift
//  udacityStudies
//
//  Created by Cris Messias on 24/02/25.
//

import SwiftUI

struct JokeView: View {
    var modelData: FetchData

    var body: some View {
        VStack {
            Text(modelData.joke)
                .padding()
                .multilineTextAlignment(.center)

            Button(action: modelData.fetchJoke) {
                Text("Get a new joke")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }

}
