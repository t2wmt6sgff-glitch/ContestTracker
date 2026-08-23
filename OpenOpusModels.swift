import Foundation

struct OpenOpusResponse: Decodable {
    let status: OpenOpusStatus
    let request: OpenOpusRequest
    let results: [OpenOpusSearchResult]
    let next: Int?
}

struct OpenOpusStatus: Decodable {
    let success: String
    let source: String
    let rows: Int
    let processingTime: Double
    let api: String
    let version: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case source
        case rows
        case processingTime = "processingtime"
        case api
        case version
    }
}

struct OpenOpusRequest: Decodable {
    let type: String
    let search: String
    let offset: String
}

struct OpenOpusSearchResult: Decodable, Identifiable {
    let composer: OpenOpusComposer
    let work: OpenOpusWork?
    
    var id: String {
        if let work {
            return "work-\(work.id)"
        }
        
        return "composer-\(composer.id)"
    }
}

struct OpenOpusComposer: Decodable, Identifiable {
    let id: String
    let name: String
    let completeName: String
    let epoch: String
    let birth: String
    let death: String
    let portrait: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case completeName = "complete_name"
        case epoch
        case birth
        case death
        case portrait
    }
}

struct OpenOpusWork: Decodable, Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let genre: String
    let popular: String
    let recommended: String
    let searchTerms: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case genre
        case popular
        case recommended
        case searchTerms = "searchterms"
    }
}


