import UIKit

protocol TeamsRouterInput {
    func closeView()
}

final class TeamsRouter {
    // MARK: - Properties
    weak var view: UIViewController?
}


// MARK: - TeamsRouterInput

extension TeamsRouter: TeamsRouterInput {
    func closeView() {
        view?.dismiss(animated: true)
    }
    
}
