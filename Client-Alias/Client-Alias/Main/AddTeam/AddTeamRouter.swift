import UIKit

protocol AddTeamRouterInput {}

final class AddTeamRouter {
    // MARK: - Properties

    weak var view: UIViewController?
}

// MARK: - AddTeamRouterInput

extension AddTeamRouter: AddTeamRouterInput {}
