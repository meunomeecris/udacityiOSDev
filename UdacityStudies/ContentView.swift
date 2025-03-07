import SwiftUI

struct ContentView: View {
    @State private var isSignedIn: Bool = false

    var body: some View {
        if isSignedIn {
            TabView {
                TranslatorView(textToTranslate: "", translatedText: "")
                    .tabItem {
                        Label("Translaters", systemImage: "globe")
                    }

                SingOutView(isSignedIn: $isSignedIn)
                    .tabItem {
                        Label("User", systemImage: "person.circle")
                    }
            }
        } else {
            SignInView(isSignedIn: $isSignedIn)
        }
    }
}
