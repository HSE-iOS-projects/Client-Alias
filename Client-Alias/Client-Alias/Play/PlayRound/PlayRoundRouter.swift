import UIKit

protocol PlayRoundRouterInput {
    func openEndGameController(data: [WordInfo])
}

final class PlayRoundRouter {
    // MARK: - Properties

    weak var view: UIViewController?
}

// MARK: - PlayRoundRouterInput

extension PlayRoundRouter: PlayRoundRouterInput {
    // TODO: - заменить на пуш
    func openEndGameController(data: [WordInfo]) {
//        let viewController = EndGameModuleConfigurator().configure(
//            output: nil,
//            data: data
//        ).view
//
//        view?.navigationController?.pushViewController(viewController, animated: false)
    }
    
}
