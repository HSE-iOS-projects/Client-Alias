import UIKit

protocol RoomsRouterInput {

    func addKey()
}

final class RoomsRouter {
    // MARK: - Properties

    weak var view: UIViewController?
}

// MARK: - RoomsRouterInput

extension RoomsRouter: RoomsRouterInput {
    func addKey() {
        let vc = AddKeyModuleConfigurator().configure().view
        vc.sheetPresentationController?.detents = [.medium()]
        view?.present(vc, animated: true)
    }
}
