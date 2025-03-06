import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        // Setup dependencies
        let networkManager = NetworkManager.shared
        let repository = UserRepository(networkManager: networkManager)
        let viewModel = UserListViewModel(repository: repository)
        
        // Setup initial view controller
        let userListViewController = UserListViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: userListViewController)
        
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
} 