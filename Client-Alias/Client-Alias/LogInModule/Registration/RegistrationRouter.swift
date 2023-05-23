import UIKit

protocol RegistrationRouterInput {
    func openMainScreen()
    func openPreviousScreen()
}

final class RegistrationRouter {
    // MARK: - Properties

    weak var view: UIViewController?
}

// MARK: - RegistrationRouterInput

extension RegistrationRouter: RegistrationRouterInput {
    func openMainScreen() {
        let viewController = TabBarViewController()
        viewController.modalPresentationStyle = .fullScreen
        view?.present(viewController, animated: true)
    }
    
    func openPreviousScreen() {
        view?.dismiss(animated: true)
    }
}
