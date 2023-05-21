import UIKit

protocol ProfileRouterInput {}

final class ProfileRouter {
    // MARK: - Properties

    weak var view: UIViewController?
}

// MARK: - ProfileRouterInput

extension ProfileRouter: ProfileRouterInput {}
