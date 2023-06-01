import UIKit

protocol PlayRoundRouterInput {}

final class PlayRoundRouter {
    // MARK: - Properties

    weak var view: UIViewController?
}

// MARK: - PlayRoundRouterInput

extension PlayRoundRouter: PlayRoundRouterInput {}
