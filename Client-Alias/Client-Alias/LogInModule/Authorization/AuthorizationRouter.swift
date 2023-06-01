import UIKit

protocol AuthorizationRouterInput {
    func openMainScreen()
    func openRegistrationViewController()
    func showAlert()
}

final class AuthorizationRouter {
    // MARK: - Properties

    weak var view: UIViewController?
}

// MARK: - AuthorizationRouterInput

extension AuthorizationRouter: AuthorizationRouterInput {
    func openRegistrationViewController() {
        let viewController = RegistrationModuleConfigurator().configure(output: nil).view
        view?.navigationController?.pushViewController(viewController, animated: true)
    }

    func openMainScreen() {
        let viewController = TabBarViewController()
        view?.navigationController?.pushViewController(viewController, animated: true)
    }

    func showAlert() {
        view?.present(UIAlertController.makeProblemAlert(anchoredBarButtonItem: .none), animated: true, completion: nil)
    }
}
