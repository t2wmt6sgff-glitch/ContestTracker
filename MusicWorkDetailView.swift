import SwiftUI

struct MusicWorkDetailView: View {
    @Environment(\.openURL) private var openURL
    
    let work: MusicWork
    
    @State private var showingEditView = false
    @State private var showingYouTubeForm = false
    @State private var showingDeleteVideoConfirmation = false
    
    var body: some View {
        List {
            Section("Información") {
                LabeledContent("Título") {
                    Text(work.title)
                }
                
                if !work.composer.isEmpty {
                    LabeledContent("Compositor") {
                        Text(work.composer)
                    }
                }
                
                if !work.subtitle.isEmpty {
                    LabeledContent("Subtítulo") {
                        Text(work.subtitle)
                    }
                }
                
                if !work.catalogue.isEmpty {
                    LabeledContent("Catálogo") {
                        Text(work.catalogue)
                    }
                }
                
                if !work.genre.isEmpty {
                    LabeledContent("Género") {
                        Text(work.genre)
                    }
                }
            }
            
            Section("Origen") {
                LabeledContent("Fuente") {
                    Text(
                        work.isManual
                        ? "Añadida manualmente"
                        : "Open Opus"
                    )
                }
            }
            
            Section("Vídeo") {
                if let youtubeURL = work.youtubeURL,
                   let url = URL(string: youtubeURL) {
                    
                    Button {
                        openURL(url)
                    } label: {
                        Label(
                            "Ver vídeo en YouTube",
                            systemImage: "play.rectangle.fill"
                        )
                    }
                    
                    Button {
                        showingYouTubeForm = true
                    } label: {
                        Label(
                            "Cambiar vídeo",
                            systemImage: "arrow.triangle.2.circlepath"
                        )
                    }
                    
                    Button(role: .destructive) {
                        showingDeleteVideoConfirmation = true
                    } label: {
                        Label(
                            "Eliminar vídeo",
                            systemImage: "trash"
                        )
                    }
                    
                } else {
                    Button {
                        showingYouTubeForm = true
                    } label: {
                        Label(
                            "Añadir vídeo de YouTube",
                            systemImage: "plus"
                        )
                    }
                }
            }
        }
        .navigationTitle(work.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingEditView = true
                } label: {
                    Image(systemName: "pencil")
                }
                .accessibilityLabel("Editar obra")
            }
        }
        .sheet(
            isPresented: $showingEditView
        ) {
            MusicWorkEditView(work: work)
        }
        .sheet(
            isPresented: $showingYouTubeForm
        ) {
            YouTubeVideoView(work: work)
        }
        .alert(
            "Eliminar vídeo",
            isPresented: $showingDeleteVideoConfirmation
        ) {
            Button(
                "Eliminar",
                role: .destructive
            ) {
                work.youtubeURL = nil
            }
            
            Button(
                "Cancelar",
                role: .cancel
            ) {}
        } message: {
            Text(
                "¿Seguro que quieres eliminar el vídeo asociado a esta obra?"
            )
        }
    }
}

#Preview {
    NavigationStack {
        MusicWorkDetailView(
            work: MusicWork(
                title: "Nocturnes, op. 9",
                composer: "Frédéric Chopin",
                catalogue: "Op. 9",
                genre: "Keyboard"
            )
        )
    }
    .modelContainer(
        for: MusicWork.self,
        inMemory: true
    )
}
