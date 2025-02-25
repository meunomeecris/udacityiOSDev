//
//  ContentView.swift
//  UdacityStudies
//
//  Created by Cris Messias on 25/02/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Joke", systemImage: "message.circle") {
                JokeView(modelData: FetchData())            }
            .badge(2)

            Tab("User", systemImage: "person.circle") {
                RandomUser(modelData: RandomUserData())
            }
            .badge(1)
        }
    }
}
