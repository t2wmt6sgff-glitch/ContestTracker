import SwiftUI
import EventKit
import EventKitUI

struct CalendarEventEditView: UIViewControllerRepresentable {
    let title: String
    let date: Date
    let location: String
    let notes: String
    let includesTime: Bool
    
    @Binding var isPresented: Bool
    
    init(
        title: String,
        date: Date,
        location: String,
        notes: String,
        includesTime: Bool = false,
        isPresented: Binding<Bool>
    ) {
        self.title = title
        self.date = date
        self.location = location
        self.notes = notes
        self.includesTime = includesTime
        _isPresented = isPresented
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isPresented: $isPresented)
    }
    
    func makeUIViewController(
        context: Context
    ) -> EKEventEditViewController {
        let eventStore = EKEventStore()
        let event = EKEvent(eventStore: eventStore)
        let calendar = Calendar.current
        
        if includesTime {
            event.startDate = date
            event.endDate = calendar.date(
                byAdding: .hour,
                value: 1,
                to: date
            ) ?? date.addingTimeInterval(60 * 60)
            event.isAllDay = false
        } else {
            let startDate = calendar.startOfDay(for: date)
            let endDate = calendar.date(
                byAdding: .day,
                value: 1,
                to: startDate
            ) ?? startDate.addingTimeInterval(24 * 60 * 60)
            
            event.startDate = startDate
            event.endDate = endDate
            event.isAllDay = true
        }
        
        event.title = title
        
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
