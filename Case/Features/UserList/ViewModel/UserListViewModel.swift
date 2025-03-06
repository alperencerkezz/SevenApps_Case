import Foundation

// MARK: - UserList View Model
final class UserListViewModel {
    // MARK: - State
    enum State: Equatable {
        case idle
        case loading
        case loaded([UserListItem])
        case error(String)
        
        static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle):
                return true
            case (.loading, .loading):
                return true
            case let (.loaded(lhsItems), .loaded(rhsItems)):
                return lhsItems == rhsItems
            case let (.error(lhsError), .error(rhsError)):
                return lhsError == rhsError
            default:
                return false
            }
        }
    }
    
    // MARK: - View Data
    struct UserListItem: Equatable {
        let id: Int
        let name: String
        let email: String
    }
    
    // MARK: - Properties
    @Published private(set) var state: State = .idle
    @Published private(set) var navigationAction: NavigationAction?
    
    private let repository: UserRepositoryProtocol
    
    // Add a new property to track state changes
    private(set) var stateHistory: [State] = []
    
    enum NavigationAction {
        case showDetail(UserDetailViewModel)
        case showError(String)
    }
    
    // MARK: - Initialization
    init(repository: UserRepositoryProtocol = UserRepository()) {
        self.repository = repository
    }
    
    // MARK: - Public Methods
    @MainActor
    func fetchUsers() async {
        state = .loading
        stateHistory.append(.loading)
        
        do {
            let users = try await repository.fetchUsers()
            let items = users.map { UserListItem(id: $0.id, name: $0.name, email: $0.email) }
            state = .loaded(items)
            stateHistory.append(.loaded(items))
        } catch {
            state = .error(error.localizedDescription)
            stateHistory.append(.error(error.localizedDescription))
        }
    }
    
    @MainActor
    func didSelectUser(id: Int) async {
        do {
            let user = try await repository.fetchUser(id: id)
            let detailViewModel = UserDetailViewModel(user: user)
            navigationAction = .showDetail(detailViewModel)
        } catch {
            navigationAction = .showError(error.localizedDescription)
        }
    }
} 