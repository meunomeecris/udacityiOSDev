import SwiftUI

extension TranslatorView {
    func performTranslation() async throws {
        //Make sure textToTranslate is NOT EMPTY
        guard !textToTranslate.isEmpty else { return }

        ///Update the UI before the request is made
        await MainActor.run {
            translatedText = "Translating ..."
        }

        //Build URL to the make the POST request
        guard let url = URL(string: "https://deep-translate1.p.rapidapi.com/language/translate/v2") else { return }
        var urlRequest = URLRequest(url: url)

        //Add headers - Specify the format, add the API KEY and specify the Method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("13c452d106mshcb729c55f45f4dfp1a5227jsnf2a6ae51dfb2", forHTTPHeaderField: "x-rapidapi-key")
        urlRequest.httpMethod = "POST"

        //Create the Body with the model object
        let requestBody = TranslationRequest(
            input: textToTranslate,
            source: fromLanguage.rawValue,
            target: toLanguage.rawValue
        )

        //Encode the object into JSON data
        let encoder = JSONEncoder()
        let data = try encoder.encode(requestBody)
        urlRequest.httpBody = data

        //Send the request
        let (responseData, _) = try await URLSession.shared.data(for: urlRequest)


        //Decode it into the response object
        let decoder = JSONDecoder()
        let response = try decoder.decode(TranslationResponse.self, from: responseData)

        //Update UI
        await MainActor.run {
            translatedText = response.data.translations.translatedText
        }
    }
}

struct TranslatorView: View {
    @State var textToTranslate: String
    @State var translatedText: String
    
    @State private var fromLanguage: Language = .brasileiro
    @State private var toLanguage: Language = .arabic

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .foregroundStyle(.tint)
                .imageScale(.large)
                .font(.largeTitle)
            Text("The Translator")
                .foregroundStyle(.tint)
                .bold()
                .font(.title2)
                .padding(.bottom, 24)

            TextField(
                "",
                text: $textToTranslate,
                prompt:
                    Text("How to say in \(toLanguage.displayName)?")
            )
            .lineLimit(5)
            .textFieldStyle(.roundedBorder)
            .padding(.bottom, 24)


            PickerLanguage(language: $fromLanguage, labelLanguage: "From")
            PickerLanguage(language: $toLanguage, labelLanguage: "To")


            Button("Translate", systemImage: "sparkles") {
                Task {
                    do {
                        try await performTranslation()
                    } catch {
                        print(error)
                    }
                }
            }
            .padding(12)
            .foregroundColor(.white)
            .background(.tint)
            .cornerRadius(8)
            .padding(.bottom, 40)

            Text(translatedText)
                .font(.system(size: 25, design: .default))
                .foregroundStyle(.black)
                .padding()

        }
        .ignoresSafeArea(.all)
        .padding()

        Spacer()

    }
}


struct PickerLanguage: View {
    @Binding var language: Language
    var labelLanguage: String

    var body: some View {
        LabeledContent(labelLanguage) {
            Picker("", selection: $language) {
                ForEach(Language.allCases) { language in
                    Text(language.displayName)
                        .tag(language)
                }
            }
            .pickerStyle(.menu)
        }
        .font(.system(size: 18, weight: .bold, design: .default))
        .foregroundStyle(.tint)
    }
}
