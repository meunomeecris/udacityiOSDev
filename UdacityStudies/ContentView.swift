import SwiftUI

struct ContentView: View {

    var body: some View {
        TabView {
            Tab("Translaters", systemImage: "globe") {
                TranslatorView(textToTranslate: "", translatedText: "")
            }
            
            Tab("Joke", systemImage: "message.circle") {
                JokeView(modelData: FetchData())
            }
            .badge(2)

            Tab("User", systemImage: "person.circle") {
                UserView()
            }
        }
    }
}
