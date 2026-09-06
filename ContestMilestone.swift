import Foundation
import SwiftData

@Model
final class ContestMilestone {
    var id: UUID
    var title: String
    var date: Date
    var includesTime: Bool
    var notes: String
    var reminderIdentifier: String?
    
    init(
        title: String,
        date: Date,
        includesTime: Bool = false,
        notes: String = "",
        reminderIdentifier: String? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.date = date
        self.includesTime = includesTime
        self.notes = notes
        self.reminderIdentifier = reminderIdentifier
    }
}
