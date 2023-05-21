import UIKit

protocol AddKeyRouterInput {}

final class AddKeyRouter {
    // MARK: - Properties

    weak var view: UIViewController?
}

// MARK: - AddKeyRouterInput

extension AddKeyRouter: AddKeyRouterInput {}
