import SwiftUI
import KeychainSwift

struct ContentView: View {
    @AppStorage("isSignedIn") var isSignedIn = false

    var body: some View {
        Group {
            if isSignedIn {
                TabView {
                    TranslatorView(textToTranslate: "", translatedText: "")
                        .tabItem {
                            Label("Translaters", systemImage: "globe")
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
