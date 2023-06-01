import UIKit

protocol EndGameRouterInput {}

final class EndGameRouter {
    // MARK: - Properties

    weak var view: UIViewController?
}

// MARK: - EndGameRouterInput

extension EndGameRouter: EndGameRouterInput {}
