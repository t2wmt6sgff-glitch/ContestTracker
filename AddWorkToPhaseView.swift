import SwiftUI
import SwiftData

struct AddWorkToPhaseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \MusicWork.composer)
    private var works: [MusicWork]
    
    let phase: ContestPhase
    
    @State private var searchText = ""
    @State private var showingPlaceholderForm = false
    @State private var placeholderText = ""
    
    private var filteredWorks: [MusicWork] {
        let query = searchText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        
        guard !query.isEmpty else {
            return works
        }
        
        return works.filter { work in
            work.title.localizedCaseInsensitiveContains(query)
            || work.composer.localizedCaseInsensitiveContains(query)
            || work.subtitle.localizedCaseInsensitiveContains(query)
            || work.catalogue.localizedCaseInsensitiveContains(query)
        }
    }
    
    private func isAlreadyAdded(
        _ work: MusicWork
    ) -> Bool {
        phase.repertoireItems.contains {
            $0.musicWork?.id == work.id
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Obras") {
                    if works.isEmpty {
                        Text("No hay obras guardadas.")
                            .foregroundStyle(.secondary)
                    } else if filteredWorks.isEmpty {
                        Text(
                            "No hay obras que coincidan con «\(searchText)»."
                        )
                        .foregroundStyle(.secondary)
                    } else {
                        ForEach(filteredWorks) { work in
                            Button {
                                add(work)
                            } label: {
                                HStack(spacing: 12) {
                                    VStack(
                                        alignment: .leading,
                                        spacing: 4
                                    ) {
                                        Text(work.title)
                                            .foregroundStyle(.primary)
                                        
                                        if !work.composer.isEmpty {
                                            Text(work.composer)
                                                .font(.subheadline)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    if isAlreadyAdded(work) {
                                        Image(
                                            systemName: "checkmark"
                                        )
                                        .foregroundStyle(.tint)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                            .disabled(isAlreadyAdded(work))
                        }
                    }
                }
                
                Section("Elemento provisional") {
                    Button {
                        placeholderText = ""
                        showingPlaceholderForm = true
                    } label: {
                        Label(
                            "Añadir elemento provisional",
                            systemImage: "questionmark.circle"
                        )
                    }
                }
            }
            .searchable(
                text: $searchText,
                prompt: "Buscar en mis obras"
            )
            .navigationTitle("Añadir obra")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
            .alert(
                "Elemento provisional",
                isPresented: $showingPlaceholderForm
            ) {
                TextField(
                    "Ej. Obra española",
                    text: $placeholderText
                )
                
                Button("Cancelar", role: .cancel) {
                    placeholderText = ""
                }
                
                Button("Añadir") {
                    addPlaceholder()
                }
                .disabled(
                    placeholderText
                        .trimmingCharacters(
                            in: .whitespacesAndNewlines
                        )
                        .isEmpty
                )
            } message: {
                Text(
                    "Escribe qué tipo de obra tienes previsto tocar aunque todavía no hayas decidido cuál será."
                )
            }
        }
    }
    
    private func add(
        _ work: MusicWork
    ) {
        guard !isAlreadyAdded(work) else {
            return
        }
        
        let item = ContestRepertoireItem(
            musicWork: work
        )
        
        phase.repertoireItems.append(item)
        modelContext.insert(item)
    }
    
    private func addPlaceholder() {
        let text = placeholderText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        
        guard !text.isEmpty else {
            return
        }
        
        let item = ContestRepertoireItem(
            placeholder: text
        )
        
        phase.repertoireItems.append(item)
        modelContext.insert(item)
        
        placeholderText = ""
    }
}
