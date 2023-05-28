import UIKit

protocol AuthorizationRouterInput {
    func openMainScreen()
    func openRegistrationViewController()
}

final class AuthorizationRouter {
    // MARK: - Properties

    weak var view: UIViewController?
}

// MARK: - AuthorizationRouterInput

extension AuthorizationRouter: AuthorizationRouterInput {
    
    func openRegistrationViewController() {
        let viewController = RegistrationModuleConfigurator().configure(output: nil).view
//        viewController.modalPresentationStyle = .fullScreen
//        view?.present(viewController, animated: true)
        view?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func openMainScreen() {
        let viewController = TabBarViewController()
        viewController.modalPresentationStyle = .fullScreen
        view?.present(viewController, animated: true)
    }
    
}
