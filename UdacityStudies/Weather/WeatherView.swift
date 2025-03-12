import SwiftUI
import Network

/*
 Integrating Async and Await for Network Requests
 Implementing User Feedback Mechanisms
 Handling Offline Connections and Poor Connectivity
 */

struct WeatherView: View {
    @State private var weather: String = "Loading..."
    @State private var isLoading: Bool = true
    @State private var errorMessage: String?
    @State private var isConnected: Bool = true

    let monitor = NWPathMonitor()

    var body: some View {
        VStack {
            if !isConnected {
                Text("No Internet Connection")
                    .foregroundColor(.red)
                    .padding()
            }
            if isLoading {
                ProgressView()
                    .padding()
            } else {
                Text(weather)
                    .padding()
            }
            if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                Button(action: {
                    Task { await fetchWeather() }
                }) {
                    Text("Retry")
                }
                .padding()
            }
        }
        .onAppear {
            monitor.pathUpdateHandler = { path in
                isConnected = path.status == .satisfied
            }
            let queue = DispatchQueue(label: "Monitor")
            monitor.start(queue: queue)
        }
        .task {
            await fetchWeather()
        }
    }


    // Async function to fetch weather data
    func fetchWeather() async {
        if isConnected {
            isLoading = true
            errorMessage = nil
            do {
                weather = try await fetchWeatherData()
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        } else {
            errorMessage = "No Internet Connection"
        }
    }

    // Mock async function to simulate fetching weather data
    func fetchWeatherData() async throws -> String {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        // Simulate a possible error
        if Bool.random() {
            throw URLError(.badServerResponse)
        }
        return "Sunny 25°C"
    }
}

enum ViewState {
    case loading
    case success(String)
    case error(String)
}

struct WeatherEnumsView: View {
    @State private var state: ViewState = .loading

    var body: some View {
        VStack {
            switch state {
            case .loading:
                ProgressView() // Show loading indicator
                    .padding()
            case .success(let data):
                Text(data) // Display fetched data
                    .padding()
            case .error(let errorMessage):
                Text("Error: \(errorMessage)") // Show error message
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
