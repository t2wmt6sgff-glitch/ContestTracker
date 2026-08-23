import SwiftUI
import SwiftData

@main
struct ContestTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(
            for: [
                Contest.self,
                MusicWork.self,
                ContestPhase.self,
                ContestRepertoireItem.self,
                ContestArchive.self
            ]
        )
    }
}
