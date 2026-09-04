import Foundation
import SwiftData

@Model
final class ContestPhase {
    var id: UUID
    var name: String
    var order: Int
    
    @Relationship(deleteRule: .cascade)
    var repertoireItems: [ContestRepertoireItem]
    
    init(
        name: String,
        order: Int = 0
    ) {
        self.id = UUID()
        self.name = name
        self.order = order
        self.repertoireItems = []
    }
}

