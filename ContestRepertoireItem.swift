import Foundation
import SwiftData

enum RepertoirePreparationStatus: String, CaseIterable, Identifiable {
    case notStarted = "not_started"
    case inPreparation = "in_preparation"
    case prepared = "prepared"
    case competitionReady = "competition_ready"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .notStarted:
            return "Sin empezar"
        case .inPreparation:
            return "En preparación"
        case .prepared:
            return "Preparada"
        case .competitionReady:
            return "Lista para concurso"
        }
    }
}

@Model
final class ContestRepertoireItem {
    var id: UUID
    
    var musicWork: MusicWork?
    var placeholder: String?
    var preparationStatusRawValue: String?

    var preparationStatus: RepertoirePreparationStatus {
        get {
            guard let preparationStatusRawValue else {
                return .notStarted
            }

            return RepertoirePreparationStatus(
                rawValue: preparationStatusRawValue
            ) ?? .notStarted
        }
        set {
            preparationStatusRawValue = newValue.rawValue
        }
    }
    
    init(
        musicWork: MusicWork? = nil,
        placeholder: String? = nil
    ) {
        self.id = UUID()
        self.musicWork = musicWork
        self.placeholder = placeholder
        self.preparationStatusRawValue = RepertoirePreparationStatus
            .notStarted
            .rawValue
    }
}
