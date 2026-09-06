import SwiftUI
import EventKit
import EventKitUI

struct CalendarEventEditView: UIViewControllerRepresentable {
    let title: String
    let date: Date
    let location: String
    let notes: String
    
    @Binding var isPresented: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isPresented: $isPresented)
    }
    
    func makeUIViewController(
        context: Context
    ) -> EKEventEditViewController {
        let eventStore = EKEventStore()
        let event = EKEvent(eventStore: eventStore)
        
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.date(
            byAdding: .day,
            value: 1,
            to: startDate
        ) ?? startDate.addingTimeInterval(24 * 60 * 60)
        
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.isAllDay = true
        
        let trimmedLocation = location.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        
        if !trimmedLocation.isEmpty {
            event.location = trimmedLocation
        }
        
        let trimmedNotes = notes.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        
        if !trimmedNotes.isEmpty {
            event.notes = trimmedNotes
        }
        
        let editor = EKEventEditViewController()
        editor.eventStore = eventStore
        editor.event = event
        editor.editViewDelegate = context.coordinator
        
        return editor
    }
    
    func updateUIViewController(
        _ uiViewController: EKEventEditViewController,
        context: Context
    ) {
    }
    
    final class Coordinator: NSObject, EKEventEditViewDelegate {
        @Binding private var isPresented: Bool
        
        init(isPresented: Binding<Bool>) {
            _isPresented = isPresented
        }
        
        func eventEditViewController(
            _ controller: EKEventEditViewController,
            didCompleteWith action: EKEventEditViewAction
        ) {
            isPresented = false
        }
    }
}
