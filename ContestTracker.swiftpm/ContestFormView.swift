import SwiftUI
import SwiftData

struct ContestFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    private let contest: Contest?
    
    @State private var name: String
    @State private var date: Date
    @State private var location: String
    @State private var notes: String
    
    init(contest: Contest? = nil) {
        self.contest = contest
        
        _name = State(initialValue: contest?.name ?? "")
        _date = State(initialValue: contest?.date ?? Date())
        _location = State(initialValue: contest?.location ?? "")
        _notes = State(initialValue: contest?.notes ?? "")
    }
    
    private var isEditing: Bool {
        contest != nil
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Información") {
                    TextField("Nombre", text: $name)
                    
                    DatePicker(
                        "Fecha",
                        selection: $date,
                        displayedComponents: .date
                    )
                    
                    TextField("Lugar", text: $location)
                }
                
                Section("Notas") {
                    TextField(
                        "Notas (opcional)",
                        text: $notes,
                        axis: .vertical
                    )
                }
            }
            .navigationTitle(isEditing ? "Editar concurso" : "Nuevo concurso")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        saveContest()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
    
    private func saveContest() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedLocation = location.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            return
        }
        
        if let contest {
            // Editar el concurso existente.
            contest.name = trimmedName
            contest.date = date
            contest.location = trimmedLocation
            contest.notes = trimmedNotes
        } else {
            // Crear un concurso nuevo.
            let contest = Contest(
                name: trimmedName,
                date: date,
                location: trimmedLocation,
                notes: trimmedNotes
            )
            
            modelContext.insert(contest)
        }
        
        dismiss()
    }
}

#Preview {
    ContestFormView()
        .modelContainer(for: Contest.self, inMemory: true)
}
