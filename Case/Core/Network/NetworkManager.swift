import Foundation

// MARK: - Network Errors
enum NetworkError: LocalizedError, Equatable {
    case invalidURL
    case noData
    case decodingError
    case serverError(Int)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        case .serverError(let code):
            return "Server error: \(code)"
        case .unknown:
            return "Unknown error occurred"
        }
    }
}

// MARK: - Network Manager Protocol
protocol NetworkManaging {
    func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

// MARK: - Network Manager Implementation
final class NetworkManager: NetworkManaging {
    static let shared = NetworkManager()
    private let baseURL: String
    private let session: URLSessionProtocol
    
    init(
        baseURL: String = "https://jsonplaceholder.typicode.com",
        session: URLSessionProtocol = URLSession.shared
    ) {
        self.baseURL = baseURL
        self.session = session
    }
    
    func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        guard let url = URL(string: baseURL + endpoint.path) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url, delegate: nil)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
} 
