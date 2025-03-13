
import SwiftUI
import Network

/*
 NWPathMnitor class from Network framework is a tool for manage offline scenarios and poor connectivity
 */

struct NetworkConditions: View {
    @State private var isConnected: Bool = true
    private let monitor = NWPathMonitor()

    var body: some View {
        VStack {
            if isConnected {
                Text("You are onboard!")
            } else {
                OfflineView()
            }
        }
        .onAppear {
            startMonitoring()
        }
    }

    private func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = (path.status == .satisfied)
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
}

//MARK: - User-friendly Offline Modes

struct OfflineView: View {
    var body: some View {
        VStack {
            Image(systemName: "wifi.slash")
                .font(.largeTitle)
                .padding()
            Text("You are offline")
                .font(.title)
            Text("Please check your internet connection")
                .padding()
        }
        .padding()
    }
}

//MARK: - Optimizing App Operations Under Poor Connectivity

struct LazyLoading: View {
    @State private var data: String = "Loading"
    @State private var isLoading: Bool = true

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading")
            } else {
                Text(data)
            }
        }
        .onAppear {
            Task { await fetchData() }
        }
    }

    func fetchData() async {
        isLoading = true
        do {
            data = try await fetchRemoteData()
            cacheData(data)
        } catch {
            data = loadCacheData() ?? "Failed to load data: \(error.localizedDescription)"
        }
        isLoading = false
    }

    func fetchRemoteData() async throws -> String {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        if Bool.random() {
            throw URLError(.badServerResponse)
        }
        return "Data fetched successfully"

    }

    func cacheData(_ data: String) {

    }

    func loadCacheData() -> String {
        return "Cached data"
    }
}

