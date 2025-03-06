import Foundation

final class UserDetailViewModel {
    // MARK: - Properties
    private let user: User
    
    // MARK: - View Data
    struct ViewData: Equatable {
        let name: String
        let username: String
        let email: String
        let phone: String
        let website: String
        let address: String
        let company: String
    }
    
    @Published private(set) var viewData: ViewData
    
    // MARK: - Initialization
    init(user: User) {
        self.user = user
        self.viewData = ViewData(
            name: user.name,
            username: user.username,
            email: user.email,
            phone: user.phone,
            website: user.website,
            address: "\(user.address.street), \(user.address.suite)\n\(user.address.city), \(user.address.zipcode)",
            company: "\(user.company.name)\n\(user.company.catchPhrase)"
        )
    }
} 