import SwiftUI
import SwiftData

@main
struct ContestTrackerApp: App {
    let sharedModelContainer: ModelContainer
    
    init() {
        do {
            let configuration = ModelConfiguration(
                isStoredInMemoryOnly: false
            )
            
            let container = try ModelContainer(
                for:
                    Contest.self,
                MusicWork.self,
                ContestPhase.self,
                ContestRepertoireItem.self,
                ContestArchive.self,
                configurations: configuration
            )
            
            sharedModelContainer = container
            
        } catch {
            fatalError("No se pudo crear el ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
