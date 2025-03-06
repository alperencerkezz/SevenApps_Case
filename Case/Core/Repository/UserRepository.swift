import Foundation

// MARK: - User Repository Protocol
protocol UserRepositoryProtocol {
    /// Fetches all users from the API
    /// - Returns: Array of User objects
    /// - Throws: NetworkError
    func fetchUsers() async throws -> [User]
    
    /// Fetches a specific user by ID
    /// - Parameter id: The user's ID
    /// - Returns: User object
    /// - Throws: NetworkError
    func fetchUser(id: Int) async throws -> User
}

// MARK: - User Repository Implementation
final class UserRepository: UserRepositoryProtocol {
    private let networkManager: NetworkManaging
    
    init(networkManager: NetworkManaging = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchUsers() async throws -> [User] {
        try await networkManager.fetch(.users)
    }
    
    func fetchUser(id: Int) async throws -> User {
        try await networkManager.fetch(.user(id: id))
    }
} 
