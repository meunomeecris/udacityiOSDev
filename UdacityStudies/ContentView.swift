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
//                    TranslatorView(textToTranslate: "", translatedText: "")
//                        .tabItem {
//                            Label("Translater", systemImage: "globe")
//                        }
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
