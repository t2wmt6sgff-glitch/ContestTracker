import SwiftUI
import SwiftData

struct ContestMilestonesSection: View {
    @Environment(\.modelContext) private var modelContext
    
    let contest: Contest
    let onAddMilestone: () -> Void
    let onEditMilestone: (ContestMilestone) -> Void
    let onAddMilestoneToCalendar: (ContestMilestone) -> Void
    
    @State private var milestoneToDelete: ContestMilestone?
    @State private var showingDeleteConfirmation = false
    
    @State private var reminderSavingID: UUID?
    @State private var messageTitle = "Recordatorios"
    @State private var messageText = ""
    @State private var showingMessage = false
    
    private var sortedMilestones: [ContestMilestone] {
        contest.milestones.sorted {
            $0.date < $1.date
        }
    }
    
    var body: some View {
        Section("Fechas importantes") {
            if sortedMilestones.isEmpty {
                VStack(
                    alignment: .leading,
                    spacing: 10
                ) {
                    Text(
                        "Añade plazos, ensayos, viajes u otras fechas relacionadas con el concurso."
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    
                    Button {
                        onAddMilestone()
                    } label: {
                        Label(
                            "Añadir fecha importante",
                            systemImage: "plus"
                        )
                    }
                }
                .padding(.vertical, 4)
            } else {
                ForEach(sortedMilestones) { milestone in
                    milestoneRow(milestone)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                prepareDelete(milestone)
                            } label: {
                                Label(
                                    "Eliminar",
                                    systemImage: "trash"
                                )
                            }
                            
                            Button {
                                onEditMilestone(milestone)
                            } label: {
                                Label(
                                    "Editar",
                                    systemImage: "pencil"
                                )
                            }
                        }
                }
                
                Button {
                    onAddMilestone()
                } label: {
                    Label(
                        "Añadir fecha importante",
                        systemImage: "plus"
                    )
                }
            }
        }
        .alert(
            "Eliminar fecha importante",
            isPresented: $showingDeleteConfirmation,
            presenting: milestoneToDelete
        ) { milestone in
            Button(
                "Cancelar",
                role: .cancel
            ) {
                milestoneToDelete = nil
            }
            
            Button(
                "Eliminar",
                role: .destructive
            ) {
                delete(milestone)
            }
        } message: { milestone in
            if milestone.reminderIdentifier == nil {
                Text(
                    "¿Seguro que quieres eliminar «\(milestone.title)»?"
                )
            } else {
                Text(
                    "¿Seguro que quieres eliminar «\(milestone.title)»? El recordatorio creado en la app Recordatorios no se eliminará automáticamente."
                )
            }
        }
        .alert(
            messageTitle,
            isPresented: $showingMessage
        ) {
            Button("Aceptar", role: .cancel) {
            }
        } message: {
            Text(messageText)
        }
    }
    
    private func milestoneRow(
        _ milestone: ContestMilestone
    ) -> some View {
        HStack(
            alignment: .top,
            spacing: 12
        ) {
            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                Text(milestone.title)
                    .font(.headline)
                
                Text(formattedDate(for: milestone))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text(countdownText(for: milestone.date))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                if !milestone.notes.isEmpty {
                    Text(milestone.notes)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                
                if milestone.reminderIdentifier != nil {
                    Label(
                        "Añadido a Recordatorios",
                        systemImage: "checkmark.circle"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }
            
            Spacer(minLength: 8)
            
            Menu {
                Button {
                    onAddMilestoneToCalendar(milestone)
                } label: {
                    Label(
                        "Añadir al calendario",
                        systemImage: "calendar.badge.plus"
                    )
                }
                
                Button {
                    Task {
                        await saveReminder(for: milestone)
                    }
                } label: {
                    Label(
                        milestone.reminderIdentifier == nil
                        ? "Crear recordatorio"
                        : "Actualizar recordatorio",
                        systemImage: "checklist"
                    )
                }
                .disabled(
                    reminderSavingID == milestone.id
                )
                
                Divider()
                
                Button {
                    onEditMilestone(milestone)
                } label: {
                    Label(
                        "Editar",
                        systemImage: "pencil"
                    )
                }
                
                Button(role: .destructive) {
                    prepareDelete(milestone)
                } label: {
                    Label(
                        "Eliminar",
                        systemImage: "trash"
                    )
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.title3)
                    .padding(.vertical, 4)
            }
            .accessibilityLabel(
                "Acciones para \(milestone.title)"
            )
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .contain)
    }
    
    private func prepareDelete(
        _ milestone: ContestMilestone
    ) {
        milestoneToDelete = milestone
        showingDeleteConfirmation = true
    }
    
    private func delete(
        _ milestone: ContestMilestone
    ) {
        if let index = contest.milestones.firstIndex(
            where: { $0.id == milestone.id }
        ) {
            contest.milestones.remove(at: index)
        }
        
        modelContext.delete(milestone)
        
        do {
            try modelContext.save()
            milestoneToDelete = nil
        } catch {
            messageTitle = "No se pudo guardar"
            messageText = error.localizedDescription
            showingMessage = true
        }
    }
    
    @MainActor
    private func saveReminder(
        for milestone: ContestMilestone
    ) async {
        guard reminderSavingID == nil else {
            return
        }
        
        reminderSavingID = milestone.id
        let wasAlreadyLinked = milestone.reminderIdentifier != nil
        
        do {
            let identifier = try await ReminderWriter.save(
                title: "\(milestone.title) – \(contest.name)",
                contestName: contest.name,
                date: milestone.date,
                includesTime: milestone.includesTime,
                notes: milestone.notes,
                existingIdentifier: milestone.reminderIdentifier
            )
            
            milestone.reminderIdentifier = identifier
            
            do {
                try modelContext.save()
                messageTitle = "Recordatorios"
                messageText = wasAlreadyLinked
                ? "El recordatorio se ha actualizado."
                : "El recordatorio se ha creado en la app Recordatorios."
            } catch {
                messageTitle = "Recordatorio creado"
                messageText = "El recordatorio se ha guardado en la app Recordatorios, pero Contest Tracker no pudo guardar su vínculo local: \(error.localizedDescription)"
            }
        } catch {
            messageTitle = "Recordatorios"
            messageText = error.localizedDescription
        }
        
        reminderSavingID = nil
        showingMessage = true
    }
    
    private func formattedDate(
        for milestone: ContestMilestone
    ) -> String {
        if milestone.includesTime {
            return milestone.date.formatted(
                date: .long,
                time: .shortened
            )
        }
        
        return milestone.date.formatted(
            date: .long,
            time: .omitted
        )
    }
    
    private func countdownText(
        for date: Date
    ) -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let milestoneDay = calendar.startOfDay(for: date)
        
        let days = calendar.dateComponents(
            [.day],
            from: today,
            to: milestoneDay
        ).day ?? 0
        
        if days > 1 {
            return "Faltan \(days) días"
        } else if days == 1 {
            return "Falta 1 día"
        } else if days == 0 {
            return "Hoy"
        } else if days == -1 {
            return "Hace 1 día"
        } else {
            return "Hace \(-days) días"
        }
    }
}
