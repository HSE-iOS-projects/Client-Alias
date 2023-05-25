import UIKit

protocol ResultRouterInput {}

final class ResultRouter {
    // MARK: - Properties

    weak var view: UIViewController?
}

// MARK: - ResultRouterInput

extension ResultRouter: ResultRouterInput {}
