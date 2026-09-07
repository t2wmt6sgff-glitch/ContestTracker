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

    var assignedWorkCount: Int {
        repertoireItems.filter { $0.musicWork != nil }.count
    }

    var competitionReadyWorkCount: Int {
        repertoireItems.filter {
            $0.musicWork != nil
            && $0.preparationStatus == .competitionReady
        }.count
    }

    var preparationSummary: String? {
        guard assignedWorkCount > 0 else {
            return nil
        }

        return "\(competitionReadyWorkCount) de \(assignedWorkCount) "
        + (assignedWorkCount == 1
           ? "lista para concurso"
           : "listas para concurso")
    }
}
