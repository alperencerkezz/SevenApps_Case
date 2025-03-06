import XCTest
@testable import Case

final class UserDetailViewModelTests: XCTestCase {
    private var sut: UserDetailViewModel!
    private var mockUser: User!
    
    override func setUp() {
        super.setUp()
        mockUser = User.mock(
            id: 1,
            name: "John Doe",
            username: "johndoe",
            email: "john@example.com",
            phone: "123-456-7890",
            website: "example.com",
            address: .mock(),
            company: .mock()
        )
        sut = UserDetailViewModel(user: mockUser)
    }
    
    override func tearDown() {
        sut = nil
        mockUser = nil
        super.tearDown()
    }
    
    func testViewDataMapping() {
        // Then
        XCTAssertEqual(sut.viewData.name, mockUser.name)
        XCTAssertEqual(sut.viewData.username, mockUser.username)
        XCTAssertEqual(sut.viewData.email, mockUser.email)
        XCTAssertEqual(sut.viewData.phone, mockUser.phone)
        XCTAssertEqual(sut.viewData.website, mockUser.website)
        XCTAssertEqual(
            sut.viewData.address,
            "\(mockUser.address.street), \(mockUser.address.suite)\n\(mockUser.address.city), \(mockUser.address.zipcode)"
        )
        XCTAssertEqual(
            sut.viewData.company,
            "\(mockUser.company.name)\n\(mockUser.company.catchPhrase)"
        )
    }
} 
