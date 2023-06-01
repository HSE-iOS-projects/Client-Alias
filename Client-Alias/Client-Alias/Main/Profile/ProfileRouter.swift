import UIKit

protocol ProfileRouterInput {
    func openAuthView()
}

final class ProfileRouter {
    // MARK: - Properties

    weak var view: UIViewController?
}

// MARK: - ProfileRouterInput

extension ProfileRouter: ProfileRouterInput {
    func openAuthView() {
        let vc = AuthorizationModuleConfigurator().configure().view
        view?.navigationController?.pushViewController(vc, animated: true)
    }
}
