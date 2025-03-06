import UIKit
import Combine

final class UserListViewController: UIViewController {
    // MARK: - UI Components
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        return tableView
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemRed
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    // MARK: - Properties
    private let viewModel: UserListViewModel
    private var cancellables = Set<AnyCancellable>()
    private var items: [UserListViewModel.UserListItem] = []
    
    // MARK: - Initialization
    init(viewModel: UserListViewModel = UserListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        Task {
            await viewModel.fetchUsers()
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        title = "Users"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        view.addSubview(errorLabel)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: - Bindings
    private func setupBindings() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleState(state)
            }
            .store(in: &cancellables)
        
        viewModel.$navigationAction
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] action in
                self?.handleNavigation(action)
            }
            .store(in: &cancellables)
    }
    
    private func handleState(_ state: UserListViewModel.State) {
        switch state {
        case .idle:
            loadingIndicator.stopAnimating()
            errorLabel.isHidden = true
            tableView.isHidden = false
            
        case .loading:
            loadingIndicator.startAnimating()
            errorLabel.isHidden = true
            tableView.isHidden = true
            
        case .loaded(let items):
            loadingIndicator.stopAnimating()
            errorLabel.isHidden = true
            tableView.isHidden = false
            self.items = items
            tableView.reloadData()
            
        case .error(let message):
            loadingIndicator.stopAnimating()
            errorLabel.isHidden = false
            errorLabel.text = message
            tableView.isHidden = true
        }
    }
    
    private func handleNavigation(_ action: UserListViewModel.NavigationAction) {
        switch action {
        case .showDetail(let detailViewModel):
            let detailViewController = UserDetailViewController(viewModel: detailViewModel)
            navigationController?.pushViewController(detailViewController, animated: true)
        case .showError(let message):
            // Show error alert
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource
extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as? UserTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: items[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension UserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        Task {
            await viewModel.didSelectUser(id: item.id)
        }
    }
} 