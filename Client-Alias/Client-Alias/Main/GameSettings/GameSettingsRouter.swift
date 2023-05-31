import UIKit

protocol GameSettingsRouterInput {
    func openGame()
}

final class GameSettingsRouter {
    // MARK: - Properties

    weak var view: UIViewController?
    
}

// MARK: - GameSettingsRouterInput

extension GameSettingsRouter: GameSettingsRouterInput {
    func openGame() {
        let vc = PlayRoundModuleConfigurator().configure().view
        view?.navigationController?.pushViewController(vc, animated: true)
    }
}
