
import Foundation

@Observable @MainActor
class ModelData {
    var users: [User]? = nil

    func getUsersFromAPI() async throws -> UserData {
        // Define the API endpoint
        guard let url = URL(string: "https://randomuser.me/api/") else {
            throw URLError(.badURL)
        }

        // Await the network request
        let (data, _) = try await URLSession.shared.data(from: url)

        // Decode the JSON data into our Swift model
        let decodedResponse = try JSONDecoder().decode(UserData.self, from: data)

        // Return the data
        return decodedResponse
    }

    func getUser() {
        Task {
            do {
                // Call the async function to fetch data
                let fetchedUser = try await getUsersFromAPI()
                
                // Update the UI on the main thread
                DispatchQueue.main.async {
                    self.users = fetchedUser.results
                }

            } catch {
                // Handle errors and update the UI on the main thread
                DispatchQueue.main.async {
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
            }
        }
    }
}
