import Foundation
import SwiftData

@Model
final class ContestRepertoireItem {
    var id: UUID
    
    var musicWork: MusicWork?
    var placeholder: String?
    
    init(
        musicWork: MusicWork? = nil,
        placeholder: String? = nil
    ) {
        self.id = UUID()
        self.musicWork = musicWork
        self.placeholder = placeholder
    }
}

