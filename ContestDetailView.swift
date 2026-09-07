import SwiftUI
import SwiftData

private enum ContestDetailSheet: Identifiable {
    case contestCalendar
    case addMilestone
    case editMilestone(ContestMilestone)
    case milestoneCalendar(ContestMilestone)
    
    var id: String {
        switch self {
        case .contestCalendar:
            return "contest-calendar"
        case .addMilestone:
            return "add-milestone"
        case .editMilestone(let milestone):
            return "edit-milestone-\(milestone.id.uuidString)"
        case .milestoneCalendar(let milestone):
            return "milestone-calendar-\(milestone.id.uuidString)"
        }
    }
}

struct ContestDetailView: View {
    @Environment(\.modelContext) private var modelContext
    
    let contest: Contest
    
    @State private var showingAddPhase = false
    @State private var newPhaseName = ""
    
    @State private var phaseToDelete: ContestPhase?
    @State private var showingDeletePhaseConfirmation = false
    @State private var activeSheet: ContestDetailSheet?
    
    private var sortedPhases: [ContestPhase] {
        contest.phases.sorted {
            $0.order < $1.order
        }
    }
    
    var body: some View {
        List {
            Section("Información") {
                LabeledContent("Nombre") {
                    Text(contest.name)
                        .multilineTextAlignment(.trailing)
                }
                
                LabeledContent("Fecha") {
                    Text(contest.date, style: .date)
                }
                
                if !contest.location.isEmpty {
                    LabeledContent("Lugar") {
                        Text(contest.location)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            
            Section("Cuenta atrás") {
                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {
                    Text(
                        countdownText(
                            for: contest.date
                        )
                    )
                    .font(.title2)
                    .fontWeight(.semibold)
                    
                    Text(
                        contest.date,
                        style: .date
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                .accessibilityElement(
                    children: .combine
                )
                .accessibilityLabel(
                    "Cuenta atrás: \(countdownText(for: contest.date)). " +
                    "Fecha del concurso: \(formattedDate(for: contest.date))"
                )
            }
            
            Section("Acciones") {
                Button {
                    activeSheet = .contestCalendar
                } label: {
                    Label(
                        "Añadir al calendario",
                        systemImage: "calendar.badge.plus"
                    )
                }
            }
            
            ContestMilestonesSection(
                contest: contest,
                onAddMilestone: {
                    activeSheet = .addMilestone
                },
                onEditMilestone: { milestone in
                    activeSheet = .editMilestone(milestone)
                },
                onAddMilestoneToCalendar: { milestone in
                    activeSheet = .milestoneCalendar(milestone)
                }
            )
            
            Section("Repertorio") {
                if sortedPhases.isEmpty {
                    emptyPhasesView
                } else {
                    ForEach(sortedPhases) { phase in
                        NavigationLink {
                            ContestPhaseDetailView(
                                phase: phase
                            )
                        } label: {
                            phaseRow(phase)
                        }
                        .contextMenu {
                            Button(
                                role: .destructive
                            ) {
                                phaseToDelete = phase
                                showingDeletePhaseConfirmation = true
                            } label: {
                                Label(
                                    "Eliminar fase",
                                    systemImage: "trash"
                                )
                            }
                        }
                    }
                    
                    Button {
                        newPhaseName = ""
                        showingAddPhase = true
                    } label: {
                        Label(
                            "Añadir fase",
                            systemImage: "plus"
                        )
                    }
                }
            }
            
            if !contest.notes.isEmpty {
                Section("Notas") {
                    Text(contest.notes)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                }
            }
        }
        .navigationTitle("Detalle")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .contestCalendar:
                CalendarEventEditView(
                    title: contest.name,
                    date: contest.date,
                    location: contest.location,
                    notes: contest.notes,
                    isPresented: activeSheetIsPresented
                )
                
            case .addMilestone:
                ContestMilestoneFormView(
                    contest: contest
                )
                
            case .editMilestone(let milestone):
                ContestMilestoneFormView(
                    contest: contest,
                    milestone: milestone
                )
                
            case .milestoneCalendar(let milestone):
                CalendarEventEditView(
                    title: "\(milestone.title) – \(contest.name)",
                    date: milestone.date,
                    location: contest.location,
                    notes: milestone.notes,
                    includesTime: milestone.includesTime,
                    isPresented: activeSheetIsPresented
                )
            }
        }
        
        // MARK: - Nueva fase
        
        .alert(
            "Nueva fase",
            isPresented: $showingAddPhase
        ) {
            TextField(
                "Nombre de la fase",
                text: $newPhaseName
            )
            
            Button(
                "Cancelar",
                role: .cancel
            ) {
                newPhaseName = ""
            }
            
            Button("Añadir") {
                addPhase()
            }
            .disabled(
                newPhaseName
                    .trimmingCharacters(
                        in: .whitespacesAndNewlines
                    )
                    .isEmpty
            )
        } message: {
            Text(
                "Introduce el nombre de la fase del concurso."
            )
        }
        
        // MARK: - Eliminar fase
        
        .alert(
            "Eliminar fase",
            isPresented: $showingDeletePhaseConfirmation,
            presenting: phaseToDelete
        ) { phase in
            Button(
                "Cancelar",
                role: .cancel
            ) {
                phaseToDelete = nil
            }
            
            Button(
                "Eliminar",
                role: .destructive
            ) {
                deletePhase(phase)
            }
        } message: { phase in
            Text(
                "¿Seguro que quieres eliminar «\(phase.name)»? " +
                "También se eliminarán las obras asignadas a esta fase."
            )
        }
    }
    
    private var activeSheetIsPresented: Binding<Bool> {
        Binding(
            get: {
                activeSheet != nil
            },
            set: { isPresented in
                if !isPresented {
                    activeSheet = nil
                }
            }
        )
    }
    
    // MARK: - Empty Phases
    
    private var emptyPhasesView: some View {
        VStack(spacing: 16) {
            ContentUnavailableView {
                Label(
                    "No hay fases",
                    systemImage: "rectangle.stack"
                )
            } description: {
                Text(
                    "Añade una fase para comenzar a organizar el repertorio."
                )
            }
            
            Button {
                newPhaseName = ""
                showingAddPhase = true
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "plus")
                    
                    Text("Añadir fase")
                }
                .frame(minWidth: 120)
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(
            maxWidth: .infinity
        )
        .listRowInsets(
            EdgeInsets(
                top: 12,
                leading: 0,
                bottom: 12,
                trailing: 0
            )
        )
    }
    
    // MARK: - Phase Row
    
    private func phaseRow(
        _ phase: ContestPhase
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            Text(phase.name)
                .font(.headline)
                .foregroundStyle(.primary)
            
            if phase.repertoireItems.isEmpty {
                Label(
                    "Sin obras",
                    systemImage: "music.note"
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
            } else {
                VStack(
                    alignment: .leading,
                    spacing: 6
                ) {
                    ForEach(
                        phase.repertoireItems
                    ) { item in
                        repertoireItemRow(item)
                    }
                }
                
                Text(
                    phase.repertoireItems.count == 1
                    ? "1 obra"
                    : "\(phase.repertoireItems.count) obras"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.top, 2)

                if let preparationSummary = phase.preparationSummary {
                    Text(preparationSummary)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 6)
        .accessibilityElement(
            children: .combine
        )
        .accessibilityLabel(
            phaseAccessibilityLabel(
                for: phase
            )
        )
    }
    
    // MARK: - Repertoire Item
    
    @ViewBuilder
    private func repertoireItemRow(
        _ item: ContestRepertoireItem
    ) -> some View {
        if let work = item.musicWork {
            HStack(spacing: 8) {
                Image(
                    systemName: "music.note"
                )
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
                
                VStack(
                    alignment: .leading,
                    spacing: 2
                ) {
                    Text(work.title)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                    
                    if !work.composer.isEmpty {
                        Text(work.composer)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .accessibilityElement(
                children: .combine
            )
            .accessibilityLabel(
                work.composer.isEmpty
                ? work.title
                : "\(work.title), \(work.composer)"
            )
        } else if let placeholder = item.placeholder,
                  !placeholder.trimmingCharacters(
                    in: .whitespacesAndNewlines
                  ).isEmpty {
            HStack(spacing: 8) {
                Image(
                    systemName: "questionmark.circle"
                )
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
                
                VStack(
                    alignment: .leading,
                    spacing: 2
                ) {
                    Text(placeholder)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                    
                    Text("Por decidir")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .accessibilityElement(
                children: .combine
            )
            .accessibilityLabel(
                "\(placeholder), por decidir"
            )
        }
    }
    
    // MARK: - Add Phase
    
    private func addPhase() {
        let name = newPhaseName.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        
        guard !name.isEmpty else {
            return
        }
        
        let nextOrder = (
            sortedPhases
                .map(\.order)
                .max() ?? -1
        ) + 1
        
        let phase = ContestPhase(
            name: name,
            order: nextOrder
        )
        
        contest.phases.append(phase)
        modelContext.insert(phase)
        
        newPhaseName = ""
    }
    
    // MARK: - Delete Phase
    
    private func deletePhase(
        _ phase: ContestPhase
    ) {
        if let index = contest.phases.firstIndex(
            where: { $0.id == phase.id }
        ) {
            contest.phases.remove(
                at: index
            )
        }
        
        modelContext.delete(phase)
        phaseToDelete = nil
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
        } else if days == 0 {
            return "Hoy"
        } else {
            return "Finalizado"
        }
    }
    
    // MARK: - Accessibility
    
    private func formattedDate(
        for date: Date
    ) -> String {
        date.formatted(
            date: .long,
            time: .omitted
        )
    }
    
    private func phaseAccessibilityLabel(
        for phase: ContestPhase
    ) -> String {
        let count = phase.repertoireItems.count
        
        if count == 0 {
            return "\(phase.name), sin obras"
        }
        
        let workText = count == 1
        ? "1 obra"
        : "\(count) obras"
        
        if let preparationSummary = phase.preparationSummary {
            return "\(phase.name), \(workText), \(preparationSummary)"
        }

        return "\(phase.name), \(workText)"
    }
}

#Preview {
    ContestDetailView(
        contest: Contest(
            name: "Concurso de prueba",
            date: Date(),
            location: "Jerez",
            notes: "Notas de prueba"
        )
    )
    .modelContainer(
        for: [
            Contest.self,
            MusicWork.self,
            ContestPhase.self,
            ContestRepertoireItem.self,
            ContestMilestone.self
        ],
        inMemory: true
    )
}
