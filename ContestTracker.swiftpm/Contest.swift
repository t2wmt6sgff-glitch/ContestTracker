import Foundation
import SwiftData

@Model
final class Contest {
    var name: String
    var date: Date
    var location: String
    var notes: String
    
    @Relationship(deleteRule: .cascade)
    var phases: [ContestPhase]
    
    init(
        name: String,
        date: Date,
        location: String = "",
        notes: String = ""
    ) {
        self.name = name
        self.date = date
        self.location = location
        self.notes = notes
        self.phases = []
    }
}
