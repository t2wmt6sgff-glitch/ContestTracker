import Foundation
import SwiftData

@Model
final class MusicWork {
    var id: UUID
    var openOpusID: String?
    
    var title: String
    var subtitle: String
    var composer: String
    var catalogue: String
    var genre: String
    
    var isManual: Bool
    
    var youtubeURL: String?
    
    init(
        openOpusID: String? = nil,
        title: String,
        subtitle: String = "",
        composer: String = "",
        catalogue: String = "",
        genre: String = "",
        isManual: Bool = false,
        youtubeURL: String? = nil
    ) {
        self.id = UUID()
        self.openOpusID = openOpusID
        self.title = title
        self.subtitle = subtitle
        self.composer = composer
        self.catalogue = catalogue
        self.genre = genre
        self.isManual = isManual
        self.youtubeURL = youtubeURL
    }
}
