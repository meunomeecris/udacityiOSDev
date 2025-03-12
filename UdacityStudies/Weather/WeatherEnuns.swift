import SwiftUI

enum RequestState {
    case idle
    case loading
    case success(String)
    case error(String)
}

struct SubmitButtonView: View {
    @State private var state: RequestState = .idle // State to track the request status

    var body: some View {
        VStack {
            switch state {
            case .idle:
                Text("Ready to fetch data")
            case .loading:
                ProgressView("Loading...") // Show loading indicator
            case .success(let data):
                Text("Data: \(data)") // Display fetched data
            case .error(let message):
                Text("Error: \(message)") // Show error message
                    .foregroundColor(.red)
                Button(action: {
                    Task { await fetchData() } // Retry button to re-fetch data
                }) {
                    Text("Retry")
                }
            }
        }
        .task {
            await fetchData() // Initiate async operation when the view appears
        }
    }

    // Async function to fetch data
    func fetchData() async {
        state = .loading
        do {
            let data = try await fetchRemoteData() // Attempt to fetch data
            state = .success(data)
        } catch {
            state = .error(error.localizedDescription) // Handle errors
        }
    }

    // Mock async function to simulate fetching remote data
    func fetchRemoteData() async throws -> String {
        try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate network delay
        if Bool.random() {
            throw URLError(.badServerResponse) // Simulate a possible error
        }
        return "Data fetched successfully" // Return mock data
    }
}

//MARK: - Handling Multiple Concurrent Network Requests

struct MultipleRequests: View {
    @State private var image: Image? = nil
    @State private var userData: String = "Loading..."
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            if let image = image {
                image
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding()
            } else {
                ProgressView() // Show loading indicator while image is being fetched
                    .padding()
            }

            Text(userData) // Display fetched user data

            if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)") // Show error message if an error occurs
                    .foregroundColor(.red)
                Button(action: {
                    Task { await fetchData() } // Retry button to re-fetch data
                }) {
                    Text("Retry")
                }
                .padding()
            }
        }
        .task {
            await fetchData() // Initiate async operation when the view appears
        }
    }

    // Async function to fetch both image and user data
    func fetchData() async {
        do {
            async let imageData = fetchImageData() // Fetch image data concurrently
            async let userInfo = fetchUserData() // Fetch user data concurrently

            // Wait for both async operations to complete
            if let imageData = try await imageData {
                self.image = Image(uiImage: UIImage(data: imageData)!)
            }
            self.userData = try await userInfo
        } catch {
            errorMessage = error.localizedDescription // Handle errors
        }
    }

    // Mock async function to simulate fetching image data
    func fetchImageData() async throws -> Data? {
        try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate network delay
        if Bool.random() {
            throw URLError(.badServerResponse) // Simulate a possible error
        }
        return Data() // Return mock data
    }

    // Mock async function to simulate fetching user data
    func fetchUserData() async throws -> String {
        try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate network delay
        if Bool.random() {
            throw URLError(.badServerResponse) // Simulate a possible error
        }
        return "User data fetched successfully" // Return mock data
    }
}

