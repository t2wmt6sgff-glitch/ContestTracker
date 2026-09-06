import SwiftUI

struct ContestTrackerRootView: View {
    var body: some View {
        TabView {
            ContestsView()
                .tabItem {
                    Label(
                        "Concursos",
                        systemImage: "trophy"
                    )
                }
            
            WorksView()
                .tabItem {
                    Label(
                        "Obras",
                        systemImage: "music.note.list"
                    )
                }
            
            AppSettingsView()
                .tabItem {
                    Label(
                        "Ajustes",
                        systemImage: "gearshape"
                    )
                }
        }
    }
}
