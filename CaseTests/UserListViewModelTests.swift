import XCTest
@testable import Case

final class UserListViewModelTests: XCTestCase {
    private var sut: UserListViewModel!
    private var mockRepository: MockUserRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockUserRepository()
        sut = UserListViewModel(repository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testFetchUsersSuccess() async {
        // Given
        let expectedUsers = [
            User.mock(id: 1, name: "John Doe", email: "john@example.com"),
            User.mock(id: 2, name: "Jane Doe", email: "jane@example.com")
        ]
        mockRepository.mockUsers = expectedUsers
        
        // When
        await sut.fetchUsers()
        
        // Then
        if case .loaded(let items) = sut.state {
            XCTAssertEqual(items.count, 2)
            XCTAssertEqual(items[0].id, expectedUsers[0].id)
            XCTAssertEqual(items[0].name, expectedUsers[0].name)
            XCTAssertEqual(items[0].email, expectedUsers[0].email)
        } else {
            XCTFail("Expected loaded state")
        }
    }
    
    func testFetchUsersFailure() async {
        // Given
        mockRepository.shouldFail = true
        
        // When
        await sut.fetchUsers()
        
        // Then
        if case .error = sut.state {
            // Success
        } else {
            XCTFail("Expected error state")
        }
    }
    
    func testDidSelectUserSuccess() async {
        // Given
        let expectedUser = User.mock(id: 1)
        mockRepository.mockUsers = [expectedUser]
        
        // When
        await sut.didSelectUser(id: 1)
        
        // Then
        if case .showDetail = sut.navigationAction {
            // Success
        } else {
            XCTFail("Expected show detail navigation action")
        }
    }
    
    func testDidSelectUserFailure() async {
        // Given
        mockRepository.shouldFail = true
        
        // When
        await sut.didSelectUser(id: 1)
        
        // Then
        if case .showError = sut.navigationAction {
            // Success
        } else {
            XCTFail("Expected show error navigation action")
        }
    }
    
    func testInitialState() {
        // Then
        if case .idle = sut.state {
            // Success
        } else {
            XCTFail("Expected idle state")
        }
    }
    
    func testLoadingState() async {
        // Given
        mockRepository.delay = 0.5
        
        // When
        Task {
            await sut.fetchUsers()
        }
        
        // Then
        // Small delay to ensure state change is captured
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        XCTAssertTrue(sut.stateHistory.contains(.loading))
    }
} 
