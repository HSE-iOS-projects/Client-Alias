import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

//    var w: GameCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundColor = UIColor(red: 28 / 255, green: 28 / 255, blue: 30 / 255, alpha: 1)
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]

//        window.rootViewController = PlayRoundModuleConfigurator().configure(output: nil).view
////        window.rootViewController = TabBarViewController()
//        window.makeKeyAndVisible()
        
//        let navigationVC = UINavigationController(rootViewController: PlayRoundModuleConfigurator().configure(output: nil).view)
////        navigationVC.navigationBar.prefersLargeTitles = true
//        navigationVC.navigationBar.isHidden = true
//        window.rootViewController = navigationVC
//        window.makeKeyAndVisible()
       
        
//        let vc = ResultModuleConfigurator().configure(result: "You win").view
//        let navigationVC = UINavigationController(rootViewController: vc)
//        let viewController = EndGameModuleConfigurator().configure(
//            output: nil,
//            data: [WordInfo]()
//        ).view
//
//        let navigationVC = UINavigationController(rootViewController: viewController)
        
        let storage = SecureSettingsKeeperImpl()
        let navigationVC: UINavigationController
        
        if storage.authToken != nil {
            WebSocketManagerImpl.shared.connect()
            navigationVC = UINavigationController(rootViewController:TabBarViewController())
        } else {
            navigationVC = UINavigationController(rootViewController: AuthorizationModuleConfigurator().configure().view)
        }
        
        window.rootViewController = navigationVC
        window.makeKeyAndVisible()

        self.window = window

    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

