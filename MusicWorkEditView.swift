import SwiftUI

struct MusicWorkEditView: View {
    @Environment(\.dismiss) private var dismiss
    
    let work: MusicWork
    
    @State private var title: String
    @State private var composer: String
    @State private var catalogue: String
    @State private var subtitle: String
    @State private var genre: String
    
    init(work: MusicWork) {
        self.work = work
        
        _title = State(initialValue: work.title)
        _composer = State(initialValue: work.composer)
        _catalogue = State(initialValue: work.catalogue)
        _subtitle = State(initialValue: work.subtitle)
        _genre = State(initialValue: work.genre)
    }
    
    private var trimmedTitle: String {
        title.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(
                        "Título",
                        text: $title
                    )
                    
                    TextField(
                        "Compositor",
                        text: $composer
                    )
                    
                    TextField(
                        "Catálogo / número de obra",
                        text: $catalogue
                    )
                } header: {
                    Text("Información principal")
                } footer: {
                    Text(
                        "El título es el único campo obligatorio."
                    )
                }
                
                Section {
                    TextField(
                        "Subtítulo",
                        text: $subtitle
                    )
                    
                    TextField(
                        "Género",
                        text: $genre
                    )
                } header: {
                    Text("Información adicional")
                }
                
                Section {
                    LabeledContent("Fuente") {
                        Text(
                            work.isManual
                            ? "Añadida manualmente"
                            : "Open Opus"
                        )
                        .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Editar obra")
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
                    .disabled(trimmedTitle.isEmpty)
                }
            }
        }
    }
    
    private func save() {
        guard !trimmedTitle.isEmpty else {
            return
        }
        
        work.title = trimmedTitle
        
        work.composer = composer.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        
        work.catalogue = catalogue.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        
        work.subtitle = subtitle.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        
        work.genre = genre.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        
        dismiss()
    }
}

#Preview {
    MusicWorkEditView(
        work: MusicWork(
            title: "Nocturnes, op. 9",
            composer: "Frédéric Chopin",
            catalogue: "Op. 9",
            genre: "Keyboard"
        )
    )
    .modelContainer(
        for: MusicWork.self,
        inMemory: true
    )
}
