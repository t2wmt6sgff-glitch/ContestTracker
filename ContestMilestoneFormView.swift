import SwiftUI
import SwiftData

struct ContestMilestoneFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let contest: Contest
    private let milestone: ContestMilestone?
    
    @State private var title: String
    @State private var date: Date
    @State private var includesTime: Bool
    @State private var notes: String
    
    @State private var saveErrorMessage = ""
    @State private var showingSaveError = false
    
    init(
        contest: Contest,
        milestone: ContestMilestone? = nil
    ) {
        self.contest = contest
        self.milestone = milestone
        
        _title = State(initialValue: milestone?.title ?? "")
        _date = State(initialValue: milestone?.date ?? contest.date)
        _includesTime = State(initialValue: milestone?.includesTime ?? false)
        _notes = State(initialValue: milestone?.notes ?? "")
    }
    
    private var isEditing: Bool {
        milestone != nil
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Fecha importante") {
                    TextField(
                        "Título",
                        text: $title,
                        prompt: Text("Inscripción, ensayo, viaje...")
                    )
                    
                    Toggle(
                        "Incluir hora",
                        isOn: $includesTime
                    )
                    
                    DatePicker(
                        "Fecha",
                        selection: $date,
                        displayedComponents: includesTime
                        ? [.date, .hourAndMinute]
                        : [.date]
                    )
                }
                
                Section("Notas") {
                    TextField(
                        "Notas (opcional)",
                        text: $notes,
                        axis: .vertical
                    )
                }
            }
            .navigationTitle(
                isEditing
                ? "Editar fecha"
                : "Nueva fecha"
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        save()
                    }
                    .disabled(
                        title
                            .trimmingCharacters(
                                in: .whitespacesAndNewlines
                            )
                            .isEmpty
                    )
                }
            }
            .alert(
                "No se pudo guardar",
                isPresented: $showingSaveError
            ) {
                Button("Aceptar", role: .cancel) {
                }
            } message: {
                Text(saveErrorMessage)
            }
        }
    }
    
    private func save() {
        let trimmedTitle = title.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        let trimmedNotes = notes.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        
        guard !trimmedTitle.isEmpty else {
            return
        }
        
        if let milestone {
            milestone.title = trimmedTitle
            milestone.date = date
            milestone.includesTime = includesTime
            milestone.notes = trimmedNotes
        } else {
            let newMilestone = ContestMilestone(
                title: trimmedTitle,
                date: date,
                includesTime: includesTime,
                notes: trimmedNotes
            )
            
            modelContext.insert(newMilestone)
            contest.milestones.append(newMilestone)
        }
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            saveErrorMessage = error.localizedDescription
            showingSaveError = true
        }
    }
}
