import UIKit

protocol ResultRouterInput {
    func openMain()
}

final class ResultRouter {
    // MARK: - Properties

    weak var view: UIViewController?
}

// MARK: - ResultRouterInput

extension ResultRouter: ResultRouterInput {
    func openMain() {
        let viewController = TabBarViewController()
        view?.navigationController?.pushViewController(viewController, animated: true)
    }
}
