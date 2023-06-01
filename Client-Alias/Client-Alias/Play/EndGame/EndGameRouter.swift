import UIKit

protocol EndGameRouterInput {
    func openResultController()
}

final class EndGameRouter {
    // MARK: - Properties

    weak var view: UIViewController?
}

// MARK: - EndGameRouterInput

extension EndGameRouter: EndGameRouterInput {
    // TODO: - заменить на пуш
    func openResultController() {
//        let viewController = ResultModuleConfigurator().configure(
//            output: nil
//        ).view
//        view?.navigationController?.pushViewController(viewController, animated: false)
    }
}
