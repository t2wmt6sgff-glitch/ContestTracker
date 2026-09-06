import Foundation
import EventKit

@MainActor
enum ReminderWriter {
    enum ReminderError: LocalizedError {
        case accessDenied
        case noDefaultList
        
        var errorDescription: String? {
            switch self {
            case .accessDenied:
                return "Contest Tracker no tiene acceso a Recordatorios. Puedes concederlo desde Ajustes > Privacidad y seguridad > Recordatorios."
            case .noDefaultList:
                return "No se ha podido encontrar una lista de Recordatorios en la que guardar el aviso."
            }
        }
    }
    
    static func save(
        title: String,
        contestName: String,
        date: Date,
        includesTime: Bool,
        notes: String,
        existingIdentifier: String?
    ) async throws -> String {
        let eventStore = EKEventStore()
        let granted = try await eventStore.requestFullAccessToReminders()
        
        guard granted else {
            throw ReminderError.accessDenied
        }
        
        let reminder: EKReminder
        
        if let existingIdentifier,
           let existingReminder = eventStore.calendarItem(
                withIdentifier: existingIdentifier
           ) as? EKReminder {
            reminder = existingReminder
        } else {
            reminder = EKReminder(eventStore: eventStore)
            
            guard let defaultList = eventStore.defaultCalendarForNewReminders() else {
                throw ReminderError.noDefaultList
            }
            
            reminder.calendar = defaultList
        }
        
        reminder.title = title
        
        let trimmedNotes = notes.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        let contestReference = "Concurso: \(contestName)"
        
        reminder.notes = trimmedNotes.isEmpty
        ? contestReference
        : "\(contestReference)\n\n\(trimmedNotes)"
        
        let calendar = Calendar.current
        let requestedComponents: Set<Calendar.Component> = includesTime
        ? [.year, .month, .day, .hour, .minute]
        : [.year, .month, .day]
        
        var dueDateComponents = calendar.dateComponents(
            requestedComponents,
            from: date
        )
        dueDateComponents.calendar = calendar
        dueDateComponents.timeZone = calendar.timeZone
        reminder.dueDateComponents = dueDateComponents
        
        try eventStore.save(reminder, commit: true)
        return reminder.calendarItemIdentifier
    }
}
