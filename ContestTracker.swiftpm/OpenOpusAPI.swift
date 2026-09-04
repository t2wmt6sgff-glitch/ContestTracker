import Foundation

struct OpenOpusAPI {
    
    private let baseURL = "https://api.openopus.org"
    
    func searchWorks(query: String) async throws -> OpenOpusResponse {
        
        let encodedQuery = query.addingPercentEncoding(
            withAllowedCharacters: .urlPathAllowed
        ) ?? query
        
        let urlString = "\(baseURL)/omnisearch/\(encodedQuery)/0.json"
        
        guard let url = URL(string: urlString) else {
            throw OpenOpusAPIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 15
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let rawJSON = String(data: data, encoding: .utf8) {
            print("===== OPEN OPUS JSON =====")
            print(rawJSON)
            print("==========================")
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw OpenOpusAPIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw OpenOpusAPIError.httpError(httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(OpenOpusResponse.self, from: data)
        } catch {
            throw OpenOpusAPIError.decodingFailed(error)
        }
    }
}

// MARK: - Errors

enum OpenOpusAPIError: Error {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case decodingFailed(Error)
}



