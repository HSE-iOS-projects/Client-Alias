import UIKit

protocol AddTeamRouterInput {
    func closeViewController()
}

final class AddTeamRouter {
    // MARK: - Properties

    weak var view: UIViewController?
}

// MARK: - AddTeamRouterInput

extension AddTeamRouter: AddTeamRouterInput {
    func closeViewController() {
        view?.dismiss(animated: true)
    }
}
