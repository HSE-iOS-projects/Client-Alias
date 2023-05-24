import UIKit

protocol TeamsRouterInput {}

final class TeamsRouter {
    // MARK: - Properties

    weak var view: UIViewController?
}

// MARK: - TeamsRouterInput

extension TeamsRouter: TeamsRouterInput {}
