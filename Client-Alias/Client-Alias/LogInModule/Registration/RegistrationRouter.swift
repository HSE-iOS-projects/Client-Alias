import UIKit

protocol RegistrationRouterInput {}

final class RegistrationRouter {
    // MARK: - Properties

    weak var view: UIViewController?
}

// MARK: - RegistrationRouterInput

extension RegistrationRouter: RegistrationRouterInput {}
