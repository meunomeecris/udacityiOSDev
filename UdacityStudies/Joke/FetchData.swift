//
//  FetchData.swift
//  UdacityStudies
//
//  Created by Cris Messias on 25/02/25.
//

import Foundation

//@Observable
//class FetchData {
//    var joke: String = "Tap the button to fetch a joke!"
//
//    func fetchJoke() {
//        // Define the API endpoint
//        let url = URL(string: "https://official-joke-api.appspot.com/random_joke")
//        guard let urlRequest = url else { print ("\(String(describing: url)) Invalid URL"); return }
//
//        // Create a data task to fetch the data
//        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
//            // Handle errors
//            if let error = error {
//                print("Error fetching data: \(error.localizedDescription)")
//                DispatchQueue.main.async {
//                    self.joke = "Failed to fech joke: \(error.localizedDescription)"
//                }
//                return
//            }
//
//            // Ensure data is received
//            guard let data = data else {
//                print("No data received")
//                return
//            }
//
//            // Decode the JSON data
//            if let decodedResponse = try? JSONDecoder().decode(Joke.self, from: data) {
//                // Update the UI on the main thread
//                DispatchQueue.main.async {
//                    self.joke = "\(decodedResponse.setup) \n\n\(decodedResponse.punchline)"
//                }
//            } else {
//                print("Failed to decode JSON")
//            }
//        }.resume() // Start the data task
//    }
//}
//
//
//struct Joke: Codable {
//    var id: Int
//    var type: String
//    var setup: String
//    var punchline: String
//}


/// Fetch data async await pattern
@MainActor @Observable class FetchData {
    var joke: String = "Tap the button to fetch a joke!"

    // Define the async function to fetch joke data
    func getJokeFromAPI() async throws -> Joke {
        // Define the API endpoint
        guard let url = URL(string: "https://official-joke-api.appspot.com/random_joke") else {
            throw URLError(.badURL)
        }

        // Await the network request
        let (data, _) = try await URLSession.shared.data(from: url)

        // Decode the JSON data into our Swift model
        let decodedResponse = try JSONDecoder().decode(Joke.self, from: data)

        // Return the joke data
        return decodedResponse
    }

    func fetchJoke() {
        Task {
            do {
                // Call the async function to fetch joke data
                let fetchedJoke = try await getJokeFromAPI()

                // Update the UI on the main thread
                DispatchQueue.main.async {
                    self.joke = "\(fetchedJoke.setup)\n\n\(fetchedJoke.punchline)"
                }

            } catch {
                // Handle errors and update the UI on the main thread
                DispatchQueue.main.async {
                    self.joke = "Failed to fetch joke: \(error.localizedDescription)"
                }
            }
        }
    }

}

struct Joke: Codable {
    var setup: String
    var punchline: String
}
