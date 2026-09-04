import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            ContestsView()
                .tabItem {
                    Label("Concursos", systemImage: "trophy")
                }
            
            WorksView()
                .tabItem {
                    Label("Obras", systemImage: "music.note.list")
                }
        }
    }
}

struct ContestsView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Contest.date)
    private var contests: [Contest]
    
    @Query
    private var archivedContests: [ContestArchive]
    
    @State private var contestToEdit: Contest?
    @State private var contestToDelete: Contest?
    @State private var contestToArchive: Contest?
    
    @State private var showingDeleteConfirmation = false
    @State private var showingArchiveConfirmation = false
    @State private var showingContestForm = false
    @State private var showingArchivedContests = false
    
    private var activeContests: [Contest] {
        let today = Calendar.current.startOfDay(for: Date())
        
        return contests
            .filter { contest in
                !isArchived(contest) &&
                Calendar.current.startOfDay(for: contest.date) >= today
            }
            .sorted {
                $0.date < $1.date
            }
    }
    
    private var finishedContests: [Contest] {
        let today = Calendar.current.startOfDay(for: Date())
        
        return contests
            .filter { contest in
                !isArchived(contest) &&
                Calendar.current.startOfDay(for: contest.date) < today
            }
            .sorted {
                $0.date > $1.date
            }
    }
    
    private var hasVisibleContests: Bool {
        !activeContests.isEmpty || !finishedContests.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if !hasVisibleContests {
                    ContentUnavailableView(
                        "No hay concursos",
                        systemImage: "trophy",
                        description: Text(
                            "Añade tu primer concurso para comenzar."
                        )
                    )
                } else {
                    List {
                        if !activeContests.isEmpty {
                            Section("Próximos") {
                                ForEach(activeContests) { contest in
                                    contestNavigationRow(contest)
                                }
                            }
                        }
                        
                        if !finishedContests.isEmpty {
                            Section("Terminados") {
                                ForEach(finishedContests) { contest in
                                    contestNavigationRow(contest)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Concursos")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    if !archivedContests.isEmpty {
                        Button {
                            showingArchivedContests = true
                        } label: {
                            Image(systemName: "archivebox")
                        }
                        .accessibilityLabel("Concursos archivados")
                    }
                    
                    Button {
                        contestToEdit = nil
                        showingContestForm = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Añadir concurso")
                }
            }
            
            // MARK: - Crear concurso
            
            .sheet(isPresented: $showingContestForm) {
                ContestFormView()
            }
            
            // MARK: - Editar concurso
            
            .sheet(item: $contestToEdit) { contest in
                ContestFormView(
                    contest: contest
                )
            }
            
            // MARK: - Archivados
            
            .sheet(isPresented: $showingArchivedContests) {
                ArchivedContestsView()
            }
            
            // MARK: - Eliminar concurso
            
            .alert(
                "Eliminar concurso",
                isPresented: $showingDeleteConfirmation,
                presenting: contestToDelete
            ) { contest in
                Button("Cancelar", role: .cancel) {
                    contestToDelete = nil
                }
                
                Button("Eliminar", role: .destructive) {
                    modelContext.delete(contest)
                    contestToDelete = nil
                }
            } message: { contest in
                Text(
                    "¿Seguro que quieres eliminar «\(contest.name)»? " +
                    "Esta acción no se puede deshacer."
                )
            }
            
            // MARK: - Descartar concurso
            
            .alert(
                "Descartar concurso",
                isPresented: $showingArchiveConfirmation,
                presenting: contestToArchive
            ) { contest in
                Button("Cancelar", role: .cancel) {
                    contestToArchive = nil
                }
                
                Button("Descartar", role: .destructive) {
                    archive(contest)
                }
            } message: { contest in
                Text(
                    "El concurso «\(contest.name)» dejará de aparecer " +
                    "en la lista de concursos."
                )
            }
        }
    }
    
    // MARK: - Contest Navigation Row
    
    private func contestNavigationRow(
        _ contest: Contest
    ) -> some View {
        NavigationLink {
            ContestDetailView(contest: contest)
        } label: {
            contestRow(contest)
        }
        .listRowSeparator(.hidden)
        .listRowInsets(
            EdgeInsets(
                top: 0,
                leading: 16,
                bottom: 0,
                trailing: 16
            )
        )
        .contextMenu {
            Button {
                contestToEdit = contest
            } label: {
                Label(
                    "Editar",
                    systemImage: "pencil"
                )
            }
            
            if isFinished(contest) {
                Button(role: .destructive) {
                    contestToArchive = contest
                    showingArchiveConfirmation = true
                } label: {
                    Label(
                        "Descartar",
                        systemImage: "archivebox"
                    )
                }
            } else {
                Button(role: .destructive) {
                    contestToDelete = contest
                    showingDeleteConfirmation = true
                } label: {
                    Label(
                        "Eliminar",
                        systemImage: "trash"
                    )
                }
            }
        }
    }
    
    // MARK: - Contest Row
    
    private func contestRow(
        _ contest: Contest
    ) -> some View {
        let finished = isFinished(contest)
        
        return VStack(
            alignment: .leading,
            spacing: 0
        ) {
            Text(contest.name)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(
                    finished
                    ? .secondary
                    : .primary
                )
                .padding(.bottom, 12)
            
            Divider()
            
            VStack(
                alignment: .leading,
                spacing: 5
            ) {
                Text(
                    contest.date,
                    style: .date
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
                
                if !contest.location.isEmpty {
                    Text(contest.location)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 12)
            
            Divider()
            
            Text(
                finished
                ? "Finalizado"
                : countdownText(
                    for: contest.date
                )
            )
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(
                finished
                ? Color.secondary
                : Color.accentColor
            )
            .padding(.vertical, 12)
            
            Divider()
            
            Text(
                repertoireSummary(
                    for: contest
                )
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .padding(.top, 12)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding(18)
        .opacity(
            finished
            ? 0.65
            : 1.0
        )
        .background(
            RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )
            .fill(.regularMaterial)
        )
        .padding(.top, 10)
        .padding(.bottom, 14)
    }
    
    // MARK: - Finished
    
    private func isFinished(
        _ contest: Contest
    ) -> Bool {
        let calendar = Calendar.current
        
        let today = calendar.startOfDay(
            for: Date()
        )
        
        let contestDay = calendar.startOfDay(
            for: contest.date
        )
        
        return contestDay < today
    }
    
    // MARK: - Archived
    
    private func persistentIdentifierString(
        for contest: Contest
    ) -> String {
        let description = String(
            describing: contest.persistentModelID
        )
        
        guard
            let start = description.firstIndex(of: "<"),
            let end = description[start...].firstIndex(of: ">")
        else {
            return description
        }
        
        return String(
            description[
                description.index(after: start)..<end
            ]
        )
    }
    
    private func isArchived(
        _ contest: Contest
    ) -> Bool {
        let contestID = persistentIdentifierString(
            for: contest
        )
        
        return archivedContests.contains { archive in
            archive.contestID == contestID ||
            archive.contestID.contains("<\(contestID)>")
        }
    }
    
    private func archive(
        _ contest: Contest
    ) {
        let contestID = persistentIdentifierString(
            for: contest
        )
        
        let archive = ContestArchive(
            contestID: contestID
        )
        
        modelContext.insert(archive)
        
        do {
            try modelContext.save()
        } catch {
            print("Error guardando el archivado: \(error)")
        }
        
        contestToArchive = nil
    }
    
    // MARK: - Countdown
    
    private func countdownText(
        for date: Date
    ) -> String {
        let calendar = Calendar.current
        
        let today = calendar.startOfDay(
            for: Date()
        )
        
        let contestDay = calendar.startOfDay(
            for: date
        )
        
        let components = calendar.dateComponents(
            [.day],
            from: today,
            to: contestDay
        )
        
        guard let days = components.day else {
            return ""
        }
        
        if days > 1 {
            return "Faltan \(days) días"
        } else if days == 1 {
            return "Falta 1 día"
        } else {
            return "Hoy"
        }
    }
    
    // MARK: - Repertoire Summary
    
    private func repertoireSummary(
        for contest: Contest
    ) -> String {
        let phaseCount = contest.phases.count
        
        let workCount = contest.phases.reduce(0) { total, phase in
            total + phase.repertoireItems.count
        }
        
        let phaseText = phaseCount == 1
        ? "1 fase"
        : "\(phaseCount) fases"
        
        let workText = workCount == 1
        ? "1 obra"
        : "\(workCount) obras"
        
        return "\(phaseText) · \(workText)"
    }
}

// MARK: - Archived Contests View

struct ArchivedContestsView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Contest.date, order: .reverse)
    private var contests: [Contest]
    
    @Query
    private var archivedContests: [ContestArchive]
    
    @State private var contestToEdit: Contest?
    @State private var contestToRecover: Contest?
    @State private var contestToDelete: Contest?
    
    @State private var showingDeleteConfirmation = false
    @State private var showingRecoverConfirmation = false
    
    private var visibleArchivedContests: [Contest] {
        contests
            .filter { contest in
                isArchived(contest)
            }
            .sorted {
                $0.date > $1.date
            }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if visibleArchivedContests.isEmpty {
                    ContentUnavailableView(
                        "No hay concursos archivados",
                        systemImage: "archivebox",
                        description: Text(
                            "Los concursos que descartes aparecerán aquí."
                        )
                    )
                } else {
                    List {
                        ForEach(visibleArchivedContests) { contest in
                            NavigationLink {
                                ContestDetailView(contest: contest)
                            } label: {
                                archivedContestRow(contest)
                            }
                            .contextMenu {
                                Button {
                                    contestToEdit = contest
                                } label: {
                                    Label(
                                        "Editar",
                                        systemImage: "pencil"
                                    )
                                }
                                
                                Button {
                                    contestToRecover = contest
                                    showingRecoverConfirmation = true
                                } label: {
                                    Label(
                                        "Recuperar",
                                        systemImage: "arrow.uturn.backward"
                                    )
                                }
                                
                                Button(role: .destructive) {
                                    contestToDelete = contest
                                    showingDeleteConfirmation = true
                                } label: {
                                    Label(
                                        "Eliminar",
                                        systemImage: "trash"
                                    )
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Archivados")
            .navigationBarTitleDisplayMode(.inline)
            
            // MARK: - Editar
            
            .sheet(item: $contestToEdit) { contest in
                ContestFormView(
                    contest: contest
                )
            }
            
            // MARK: - Recuperar
            
            .alert(
                "Recuperar concurso",
                isPresented: $showingRecoverConfirmation,
                presenting: contestToRecover
            ) { contest in
                Button("Cancelar", role: .cancel) {
                    contestToRecover = nil
                }
                
                Button("Recuperar") {
                    recover(contest)
                }
            } message: { contest in
                Text(
                    "«\(contest.name)» volverá a aparecer en la lista " +
                    "de concursos."
                )
            }
            
            // MARK: - Eliminar
            
            .alert(
                "Eliminar concurso",
                isPresented: $showingDeleteConfirmation,
                presenting: contestToDelete
            ) { contest in
                Button("Cancelar", role: .cancel) {
                    contestToDelete = nil
                }
                
                Button("Eliminar", role: .destructive) {
                    delete(contest)
                }
            } message: { contest in
                Text(
                    "¿Seguro que quieres eliminar «\(contest.name)»? " +
                    "Esta acción eliminará también sus fases y repertorio. " +
                    "No se puede deshacer."
                )
            }
        }
    }
    
    // MARK: - Archived Check
    
    private func persistentIdentifierString(
        for contest: Contest
    ) -> String {
        let description = String(
            describing: contest.persistentModelID
        )
        
        guard
            let start = description.firstIndex(of: "<"),
            let end = description[start...].firstIndex(of: ">")
        else {
            return description
        }
        
        return String(
            description[
                description.index(after: start)..<end
            ]
        )
    }
    
    private func isArchived(
        _ contest: Contest
    ) -> Bool {
        let contestID = persistentIdentifierString(
            for: contest
        )
        
        return archivedContests.contains { archive in
            archive.contestID == contestID ||
            archive.contestID.contains("<\(contestID)>")
        }
    }
    
    // MARK: - Recover
    
    private func recover(
        _ contest: Contest
    ) {
        let contestID = persistentIdentifierString(
            for: contest
        )
        
        if let archive = archivedContests.first(
            where: {
                $0.contestID == contestID ||
                $0.contestID.contains("<\(contestID)>")
            }
        ) {
            modelContext.delete(archive)
            
            do {
                try modelContext.save()
            } catch {
                print("Error guardando la recuperación: \(error)")
            }
        }
        
        contestToRecover = nil
    }
    
    // MARK: - Delete
    
    private func delete(
        _ contest: Contest
    ) {
        let contestID = persistentIdentifierString(
            for: contest
        )
        
        if let archive = archivedContests.first(
            where: {
                $0.contestID == contestID ||
                $0.contestID.contains("<\(contestID)>")
            }
        ) {
            modelContext.delete(archive)
        }
        
        modelContext.delete(contest)
        
        contestToDelete = nil
    }
    
    // MARK: - Archived Row
    
    private func archivedContestRow(
        _ contest: Contest
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 6
        ) {
            Text(contest.name)
                .font(.headline)
            
            Text(
                contest.date,
                style: .date
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
            
            if !contest.location.isEmpty {
                Text(contest.location)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Text(
                repertoireSummary(
                    for: contest
                )
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
    }
    
    // MARK: - Repertoire Summary
    
    private func repertoireSummary(
        for contest: Contest
    ) -> String {
        let phaseCount = contest.phases.count
        
        let workCount = contest.phases.reduce(0) { total, phase in
            total + phase.repertoireItems.count
        }
        
        let phaseText = phaseCount == 1
        ? "1 fase"
        : "\(phaseCount) fases"
        
        let workText = workCount == 1
        ? "1 obra"
        : "\(workCount) obras"
        
        return "\(phaseText) · \(workText)"
    }
}
