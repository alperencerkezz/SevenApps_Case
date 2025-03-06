import Foundation
@testable import Case

final class MockUserRepository: UserRepositoryProtocol {
    var mockUsers: [User] = []
    var shouldFail = false
    var delay: TimeInterval = 0
    
    func fetchUsers() async throws -> [User] {
        if delay > 0 {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        if shouldFail {
            throw NetworkError.unknown
        }
        return mockUsers
    }
    
    func fetchUser(id: Int) async throws -> User {
        if delay > 0 {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        if shouldFail {
            throw NetworkError.unknown
        }
        return mockUsers.first { $0.id == id } ?? User.mock(id: id)
    }
} 