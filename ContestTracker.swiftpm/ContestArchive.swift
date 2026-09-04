import Foundation
import SwiftData

@Model
final class ContestArchive {
    var contestID: String
    
    init(contestID: String) {
        self.contestID = contestID
    }
}
