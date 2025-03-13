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
                    LazyLoading()
                        .tabItem {
                            Label("Connectivity", systemImage: "cable.connector.slash")
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
