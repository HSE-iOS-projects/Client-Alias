import UIKit

protocol GameSettingsRouterInput {}

final class GameSettingsRouter {
    // MARK: - Properties

    weak var view: UIViewController?
}

// MARK: - GameSettingsRouterInput

extension GameSettingsRouter: GameSettingsRouterInput {}
