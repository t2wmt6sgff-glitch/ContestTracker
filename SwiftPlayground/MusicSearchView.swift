import SwiftUI
import SwiftData

struct MusicSearchView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Query private var savedWorks: [MusicWork]
    
    private let onWorkSelected: ((MusicWork) -> Void)?
    private let isWorkAlreadyAssigned: (MusicWork) -> Bool

    @State private var searchText = ""
    @State private var results: [OpenOpusSearchResult] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var hasSearched = false
    @State private var isNetworkError = false
    
    @State private var showingManualForm = false
    @State private var selectedWork: OpenOpusWork?
    @State private var selectedComposer: OpenOpusComposer?
    
    @State private var manualTitle = ""
    @State private var manualComposer = ""
    @State private var manualCatalogue = ""
    @State private var manualSubtitle = ""
    @State private var manualGenre = ""

    init(
        onWorkSelected: ((MusicWork) -> Void)? = nil,
        isWorkAlreadyAssigned: @escaping (MusicWork) -> Bool = { _ in false }
    ) {
        self.onWorkSelected = onWorkSelected
        self.isWorkAlreadyAssigned = isWorkAlreadyAssigned
    }

    private var isSelectingForPhase: Bool {
        onWorkSelected != nil
    }
    
    private var trimmedSearchText: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private var groupedResults: [
        (
            composer: OpenOpusComposer,
            works: [OpenOpusWork]
        )
    ] {
        var groups: [
            String: (
                composer: OpenOpusComposer,
                works: [OpenOpusWork]
            )
        ] = [:]
        
        var order: [String] = []
        
        for result in results {
            let composerID = result.composer.id
            
            if groups[composerID] == nil {
                groups[composerID] = (
                    composer: result.composer,
                    works: []
                )
                
                order.append(composerID)
            }
            
            if let work = result.work {
                groups[composerID]?.works.append(work)
            }
        }
        
        return order.compactMap { groups[$0] }
    }
    
    private var hasResults: Bool {
        !groupedResults.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchSection
                
                Divider()
                
                resultsSection
            }
            .navigationTitle("Añadir obra")
            .toolbar {
                if isSelectingForPhase {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancelar") {
                            dismiss()
                        }
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        prepareManualForm()
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                    .accessibilityLabel(
                        "Añadir obra manualmente"
                    )
                }
            }
            .sheet(isPresented: $showingManualForm) {
                manualWorkForm
            }
            .alert(
                "Obra seleccionada",
                isPresented: Binding(
                    get: {
                        selectedWork != nil
                    },
                    set: { isPresented in
                        if !isPresented {
                            selectedWork = nil
                            selectedComposer = nil
                        }
                    }
                ),
                presenting: selectedWork
            ) { work in
                if canAddOpenOpusWork(work.id) {
                    Button(
                        isSelectingForPhase
                        ? "Añadir a la fase"
                        : "Añadir"
                    ) {
                        addOpenOpusWork(work)
                    }
                }
                
                Button("Cancelar", role: .cancel) {
                    selectedWork = nil
                    selectedComposer = nil
                }
            } message: { work in
                if let composer = selectedComposer {
                    Text(
                        "\(work.title)\n\(composer.completeName)"
                    )
                } else {
                    Text(work.title)
                }
            }
        }
    }
    
    // MARK: - Search
    
    private var searchSection: some View {
        VStack(spacing: 12) {
            HStack {
                TextField(
                    "Buscar compositor u obra",
                    text: $searchText
                )
                .textFieldStyle(.roundedBorder)
                .submitLabel(.search)
                .onSubmit {
                    if !trimmedSearchText.isEmpty && !isLoading {
                        Task {
                            await search()
                        }
                    }
                }
                
                Button("Buscar") {
                    Task {
                        await search()
                    }
                }
                .disabled(
                    trimmedSearchText.isEmpty || isLoading
                )
            }
            
            Button {
                prepareManualForm()
            } label: {
                Label(
                    "Añadir obra manualmente",
                    systemImage: "square.and.pencil"
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
    
    // MARK: - Results
    
    @ViewBuilder
    private var resultsSection: some View {
        if isLoading {
            VStack(spacing: 12) {
                ProgressView()
                
                Text("Buscando en Open Opus...")
                    .foregroundStyle(.secondary)
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
        } else if let errorMessage {
            errorView(message: errorMessage)
        } else if !hasSearched {
            ContentUnavailableView(
                "Busca una obra o compositor",
                systemImage: "magnifyingglass",
                description: Text(
                    "Busca una obra en Open Opus o añádela manualmente."
                )
            )
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
        } else if !hasResults {
            noResultsView
        } else {
            resultsList
        }
    }
    
    private var resultsList: some View {
        List {
            ForEach(
                groupedResults,
                id: \.composer.id
            ) { group in
                Section {
                    if group.works.isEmpty {
                        Text("Compositor")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(group.works) { work in
                            resultRow(
                                work: work,
                                composer: group.composer
                            )
                        }
                    }
                } header: {
                    Text(group.composer.completeName)
                        .font(.headline)
                }
            }
        }
        .listStyle(.insetGrouped)
    }
    
    private func resultRow(
        work: OpenOpusWork,
        composer: OpenOpusComposer
    ) -> some View {
        let savedWork = savedWorks.first {
            $0.openOpusID == work.id
        }
        let isSaved = savedWork != nil
        let isAssigned = savedWork.map(
            isWorkAlreadyAssigned
        ) ?? false
        let isSelectable = !isSaved
        || (isSelectingForPhase && !isAssigned)
        let savedStatusLabel: String
        let resultAccessibilityLabel: String

        if isAssigned {
            savedStatusLabel = "Ya añadida a esta fase"
            resultAccessibilityLabel = "\(work.title), ya añadida a esta fase"
        } else if isSaved && isSelectingForPhase {
            savedStatusLabel = "Guardada en Obras"
            resultAccessibilityLabel = "\(work.title), guardada en Obras"
        } else if isSaved {
            savedStatusLabel = "Añadida"
            resultAccessibilityLabel = "\(work.title), ya añadida"
        } else {
            savedStatusLabel = ""
            resultAccessibilityLabel = work.title
        }
        
        return Button {
            if isSelectable {
                select(
                    work: work,
                    composer: composer
                )
            }
        } label: {
            HStack(spacing: 12) {
                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {
                    Text(work.title)
                        .font(.body)
                        .foregroundStyle(.primary)
                    
                    if !work.subtitle.isEmpty {
                        Text(work.subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    if !work.genre.isEmpty {
                        Text(work.genre)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer(minLength: 12)
                
                if isSaved {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.secondary)
                        .accessibilityLabel(savedStatusLabel)
                }
            }
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .contentShape(Rectangle())
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
        .disabled(!isSelectable)
        .accessibilityLabel(resultAccessibilityLabel)
    }
    
    private var noResultsView: some View {
        ContentUnavailableView {
            Label(
                "No se encontró la obra",
                systemImage: "music.note"
            )
        } description: {
            Text(
                "No hemos encontrado resultados para «\(trimmedSearchText)»."
            )
        } actions: {
            Button("Añadir manualmente") {
                prepareManualForm()
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(
                systemName: isNetworkError
                ? "wifi.exclamationmark"
                : "exclamationmark.circle"
            )
            .font(.system(size: 36))
            .foregroundStyle(.secondary)
            
            Text(message)
                .multilineTextAlignment(.center)
            
            HStack {
                Button("Reintentar") {
                    Task {
                        await search()
                    }
                }
                .buttonStyle(.bordered)
                .disabled(trimmedSearchText.isEmpty)
                
                Button("Añadir manualmente") {
                    prepareManualForm()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
    }
    
    // MARK: - Search Logic
    
    private func search() async {
        let query = trimmedSearchText
        
        guard !query.isEmpty else {
            return
        }
        
        hasSearched = true
        isLoading = true
        errorMessage = nil
        isNetworkError = false
        results = []
        
        do {
            let api = OpenOpusAPI()
            let response = try await api.searchWorks(query: query)
            
            results = response.results
        } catch let error as URLError {
            results = []
            
            switch error.code {
            case .notConnectedToInternet,
                    .networkConnectionLost,
                    .cannotConnectToHost,
                    .cannotFindHost,
                    .dnsLookupFailed:
                
                isNetworkError = true
                
                errorMessage = """
                No hay conexión a Internet.
                
                Puedes añadir la obra manualmente.
                """
                
            case .timedOut:
                isNetworkError = false
                
                errorMessage = """
                La conexión ha tardado demasiado.
                
                Comprueba tu conexión e inténtalo de nuevo.
                """
                
            default:
                isNetworkError = false
                
                errorMessage = """
                No se pudo realizar la búsqueda.
                
                Inténtalo de nuevo.
                """
            }
        } catch {
            results = []
            isNetworkError = false
            
            errorMessage = """
            No se pudo realizar la búsqueda.
            
            Inténtalo de nuevo.
            """
        }
        
        isLoading = false
    }
    
    // MARK: - Selection
    
    private func select(
        work: OpenOpusWork,
        composer: OpenOpusComposer
    ) {
        selectedWork = work
        selectedComposer = composer
    }
    
    // MARK: - Duplicate Check
    
    private func savedWorkInDatabase(
        _ openOpusID: String
    ) throws -> MusicWork? {
        if let savedWork = savedWorks.first(
            where: { $0.openOpusID == openOpusID }
        ) {
            return savedWork
        }

        let descriptor = FetchDescriptor<MusicWork>(
            predicate: #Predicate<MusicWork> { work in
                work.openOpusID == openOpusID
            }
        )
        
        let existingWorks = try modelContext.fetch(
            descriptor
        )

        return existingWorks.first
    }

    private func canAddOpenOpusWork(
        _ openOpusID: String
    ) -> Bool {
        guard let savedWork = savedWorks.first(
            where: { $0.openOpusID == openOpusID }
        ) else {
            return true
        }

        return isSelectingForPhase
        && !isWorkAlreadyAssigned(savedWork)
    }
    
    // MARK: - Open Opus Persistence
    
    private func addOpenOpusWork(
        _ work: OpenOpusWork
    ) {
        guard let composer = selectedComposer else {
            return
        }
        
        do {
            if let savedWork = try savedWorkInDatabase(work.id) {
                selectedWork = nil
                selectedComposer = nil

                if isSelectingForPhase,
                   !isWorkAlreadyAssigned(savedWork) {
                    onWorkSelected?(savedWork)
                }

                return
            }

            let newWork = MusicWork(
                openOpusID: work.id,
                title: work.title,
                subtitle: work.subtitle,
                composer: composer.completeName,
                genre: work.genre,
                isManual: false
            )

            modelContext.insert(newWork)

            selectedWork = nil
            selectedComposer = nil

            onWorkSelected?(newWork)
        } catch {
            selectedWork = nil
            selectedComposer = nil
            isNetworkError = false
            errorMessage = """
            No se pudo comprobar si la obra ya estaba guardada.

            Inténtalo de nuevo.
            """
        }
    }
    
    // MARK: - Manual Work
    
    private func prepareManualForm() {
        manualTitle = ""
        manualComposer = ""
        manualCatalogue = ""
        manualSubtitle = ""
        manualGenre = ""
        
        showingManualForm = true
    }
    
    private var manualWorkForm: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(
                        "Título",
                        text: $manualTitle
                    )
                    
                    TextField(
                        "Compositor",
                        text: $manualComposer
                    )
                    
                    TextField(
                        "Catálogo / número de obra",
                        text: $manualCatalogue
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
                        text: $manualSubtitle
                    )
                    
                    TextField(
                        "Género",
                        text: $manualGenre
                    )
                } header: {
                    Text("Información adicional")
                }
            }
            .navigationTitle("Añadir obra")
            .toolbar {
                ToolbarItem(
                    placement: .cancellationAction
                ) {
                    Button("Cancelar") {
                        showingManualForm = false
                    }
                }
                
                ToolbarItem(
                    placement: .confirmationAction
                ) {
                    Button("Añadir") {
                        addManualWork()
                    }
                    .disabled(
                        manualTitle
                            .trimmingCharacters(
                                in: .whitespacesAndNewlines
                            )
                            .isEmpty
                    )
                }
            }
        }
    }
    
    private func addManualWork() {
        let title = manualTitle.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        
        guard !title.isEmpty else {
            return
        }
        
        let newWork = MusicWork(
            title: title,
            subtitle: manualSubtitle.trimmingCharacters(
                in: .whitespacesAndNewlines
            ),
            composer: manualComposer.trimmingCharacters(
                in: .whitespacesAndNewlines
            ),
            catalogue: manualCatalogue.trimmingCharacters(
                in: .whitespacesAndNewlines
            ),
            genre: manualGenre.trimmingCharacters(
                in: .whitespacesAndNewlines
            ),
            isManual: true
        )
        
        modelContext.insert(newWork)

        showingManualForm = false

        if let onWorkSelected {
            onWorkSelected(newWork)
        } else {
            dismiss()
        }
    }
}

#Preview {
    MusicSearchView()
        .modelContainer(
            for: MusicWork.self,
            inMemory: true
        )
}
