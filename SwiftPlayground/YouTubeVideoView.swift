import SwiftUI

struct YouTubeVideoView: View {
    @Environment(\.dismiss) private var dismiss
    
    let work: MusicWork
    
    @State private var youtubeURL: String
    
    init(work: MusicWork) {
        self.work = work
        _youtubeURL = State(
            initialValue: work.youtubeURL ?? ""
        )
    }
    
    private var trimmedURL: String {
        youtubeURL.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
    }
    
    private var isValidYouTubeURL: Bool {
        guard let url = URL(string: trimmedURL),
              let host = url.host?.lowercased()
        else {
            return false
        }
        
        return host == "youtube.com"
        || host == "www.youtube.com"
        || host == "m.youtube.com"
        || host == "youtu.be"
        || host == "www.youtu.be"
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(
                        "Enlace de YouTube",
                        text: $youtubeURL
                    )
                    .keyboardType(.URL)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                } header: {
                    Text("Vídeo")
                } footer: {
                    Text(
                        "Pega el enlace del vídeo de YouTube que quieras asociar a esta obra."
                    )
                }
                
                if !trimmedURL.isEmpty &&
                    !isValidYouTubeURL {
                    Section {
                        Label(
                            "Introduce un enlace válido de YouTube.",
                            systemImage: "exclamationmark.circle"
                        )
                        .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Vídeo de YouTube")
            .toolbar {
                ToolbarItem(
                    placement: .cancellationAction
                ) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(
                    placement: .confirmationAction
                ) {
                    Button("Guardar") {
                        save()
                    }
                    .disabled(!isValidYouTubeURL)
                }
            }
        }
    }
    
    private func save() {
        guard isValidYouTubeURL else {
            return
        }
        
        work.youtubeURL = trimmedURL
        
        dismiss()
    }
}

#Preview {
    YouTubeVideoView(
        work: MusicWork(
            title: "Nocturnes, op. 9",
            composer: "Frédéric Chopin"
        )
    )
    .modelContainer(
        for: MusicWork.self,
        inMemory: true
    )
}

