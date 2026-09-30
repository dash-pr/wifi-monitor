import SwiftUI

@main
struct WiFiMonitorApp: App {
    @StateObject private var viewModel = WiFiMonitorViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .onAppear { viewModel.start() }
                .onDisappear { viewModel.stop() }
        }
        .windowStyle(.automatic)
    }
}
