import XCTest
@testable import Case

final class NetworkManagerTests: XCTestCase {
    private var sut: NetworkManager!
    private var session: MockURLSession!
    
    override func setUp() {
        super.setUp()
        session = MockURLSession()
        sut = NetworkManager(session: session)
    }
    
    override func tearDown() {
        sut = nil
        session = nil
        super.tearDown()
    }
    
    func testFetchUsersSuccess() async throws {
        // Given
        let endpoint = Endpoint.users
        let mockUser = User.mock(id: 1)
        let mockData = try JSONEncoder().encode([mockUser])
        session.mockData = mockData
        
        // When
        let users: [User] = try await sut.fetch(endpoint)
        
        // Then
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users.first?.id, mockUser.id)
    }
    
    func testFetchUserFailure() async {
        // Given
        let endpoint = Endpoint.user(id: 1)
        session.mockError = NetworkError.serverError(404)
        
        // When/Then
        do {
            let _: User = try await sut.fetch(endpoint)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
    
    func testInvalidURL() async {
        // Given
        let endpoint = Endpoint.user(id: 1)
        session.mockError = NetworkError.invalidURL
        
        // When/Then
        do {
            let _: User = try await sut.fetch(endpoint)
            XCTFail("Expected error to be thrown")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .invalidURL)
        } catch {
            XCTFail("Expected NetworkError")
        }
    }
    
    func testDecodingError() async {
        // Given
        let endpoint = Endpoint.user(id: 1)
        session.mockData = "invalid json".data(using: .utf8)
        
        // When/Then
        do {
            let _: User = try await sut.fetch(endpoint)
            XCTFail("Expected error to be thrown")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .decodingError)
        } catch {
            XCTFail("Expected NetworkError")
        }
    }
    
    func testServerError() async {
        // Given
        let endpoint = Endpoint.users
        session.mockResponse = HTTPURLResponse(
            url: URL(string: "https://test.com")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When/Then
        do {
            let _: [User] = try await sut.fetch(endpoint)
            XCTFail("Expected error to be thrown")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .serverError(500))
        } catch {
            XCTFail("Expected NetworkError")
        }
    }
} 