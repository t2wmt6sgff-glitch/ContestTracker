import SwiftUI
import SwiftData

struct WorksView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.openURL) private var openURL
    @Query(sort: \MusicWork.composer)
    
    private var works: [MusicWork]
    
    @State private var showingAddWork = false
    @State private var searchText = ""
    
    @State private var workToEdit: MusicWork?
    @State private var workToDelete: MusicWork?
    
    private var filteredWorks: [MusicWork] {
        let query = searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
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
    
    private var groupedWorks: [(composer: String, works: [MusicWork])] {
        var groups: [String: [MusicWork]] = [:]
        var order: [String] = []
        
        for work in filteredWorks {
            let composer = work.composer.isEmpty
            ? "Sin compositor"
            : work.composer
            
            if groups[composer] == nil {
                groups[composer] = []
                order.append(composer)
            }
            
            groups[composer]?.append(work)
        }
        
        return order.compactMap { composer in
            guard let works = groups[composer] else {
                return nil
            }
            
            return (
                composer: composer,
                works: works
            )
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if works.isEmpty {
                    emptyState
                } else {
                    worksList
                }
            }
            .navigationTitle("Obras")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddWork = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Añadir obra")
                }
            }
            .sheet(isPresented: $showingAddWork) {
                MusicSearchView()
            }
            .sheet(item: $workToEdit) { work in
                EditWorkView(work: work)
            }
            .alert(
                "Eliminar obra",
                isPresented: Binding(
                    get: {
                        workToDelete != nil
                    },
                    set: { isPresented in
                        if !isPresented {
                            workToDelete = nil
                        }
                    }
                ),
                presenting: workToDelete
            ) { work in
                Button("Eliminar", role: .destructive) {
                    delete(work)
                }
                
                Button("Cancelar", role: .cancel) {
                    workToDelete = nil
                }
            } message: { work in
                Text(
                    "¿Seguro que quieres eliminar «\(work.title)»?"
                )
            }
        }
    }
    
    // MARK: - Empty State
    
    private var emptyState: some View {
        ContentUnavailableView {
            Label(
                "No hay obras",
                systemImage: "music.note.list"
            )
        } description: {
            Text(
                "Añade obras desde Open Opus o crea una obra manualmente."
            )
        } actions: {
            Button("Añadir obra") {
                showingAddWork = true
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    // MARK: - Works List
    
    private var worksList: some View {
        VStack(spacing: 0) {
            searchBar
            
            if filteredWorks.isEmpty {
                ContentUnavailableView(
                    "No se encontraron obras",
                    systemImage: "magnifyingglass",
                    description: Text(
                        "No hay obras que coincidan con «\(searchText)»."
                    )
                )
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                )
            } else {
                List {
                    ForEach(
                        groupedWorks,
                        id: \.composer
                    ) { group in
                        Section {
                            ForEach(group.works) { work in
                                workRow(work)
                            }
                        } header: {
                            Text(group.composer)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
    }
    
    // MARK: - Search Bar
    
    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            
            TextField(
                "Buscar en mis obras...",
                text: $searchText
            )
            .textFieldStyle(.plain)
            
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Borrar búsqueda")
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
    
    // MARK: - Work Row
    
    private func workRow(_ work: MusicWork) -> some View {
        NavigationLink {
            MusicWorkDetailView(work: work)
        } label: {
            HStack(spacing: 12) {
                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {
                    Text(work.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    if !work.subtitle.isEmpty {
                        Text(work.subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    if !work.catalogue.isEmpty {
                        Text(work.catalogue)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    Text(
                        work.isManual
                        ? "Añadida manualmente"
                        : "Open Opus"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                
                Spacer(minLength: 8)
                
                if let youtubeURL = work.youtubeURL,
                   let url = URL(string: youtubeURL) {
                    Button {
                        openURL(url)
                    } label: {
                        Image(systemName: "play.rectangle.fill")
                            .foregroundStyle(.secondary)
                            .font(.body)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Ver vídeo en YouTube")
                }
            }
            .padding(.vertical, 6)
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                workToDelete = work
            } label: {
                Label(
                    "Eliminar",
                    systemImage: "trash"
                )
            }
            
            Button {
                workToEdit = work
            } label: {
                Label(
                    "Editar",
                    systemImage: "pencil"
                )
            }
            .tint(.blue)
        }
        .contextMenu {
            Button {
                workToEdit = work
            } label: {
                Label(
                    "Editar",
                    systemImage: "pencil"
                )
            }
            
            Button(role: .destructive) {
                workToDelete = work
            } label: {
                Label(
                    "Eliminar",
                    systemImage: "trash"
                )
            }
        }
    }
    
    // MARK: - Delete
    
    private func delete(_ work: MusicWork) {
        modelContext.delete(work)
        workToDelete = nil
    }
}

// MARK: - Edit Work

private struct EditWorkView: View {
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
                    HStack {
                        Text("Fuente")
                        
                        Spacer()
                        
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
    WorksView()
        .modelContainer(
            for: MusicWork.self,
            inMemory: true
        )
}
