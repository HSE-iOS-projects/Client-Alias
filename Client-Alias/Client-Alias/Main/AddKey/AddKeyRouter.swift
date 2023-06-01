import UIKit

protocol AddKeyRouterInput {
    func showAlert()
    func closeView()
}

final class AddKeyRouter {
    // MARK: - Properties

    weak var view: UIViewController?
}

// MARK: - AddKeyRouterInput

extension AddKeyRouter: AddKeyRouterInput {
    func showAlert() {
        view?.present(UIAlertController.makeProblemAlert(anchoredBarButtonItem: .none), animated: true, completion: nil)
    }

    func closeView() {
        view?.dismiss(animated: true)
    }
}
