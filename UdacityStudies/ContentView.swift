import SwiftUI
import KeychainSwift

struct ContentView: View {
    @AppStorage("isSignedIn") var isSignedIn = false

    var body: some View {
        Group {
            if isSignedIn {
                TabView {
                    WeatherView()
                        .tabItem {
                            Label("Weather", systemImage: "cloud.sun")
                        }
                    SignOutView()
                        .tabItem {
                            Label("User", systemImage: "person.circle")
                        }
                }
            } else {
                SignInView()
            }
        }
    }
}
