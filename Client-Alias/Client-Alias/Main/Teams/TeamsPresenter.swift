protocol TeamsModuleInput: AnyObject {}

protocol TeamsModuleOutput: AnyObject {}

final class TeamsPresenter {
    // MARK: - Properties

    weak var view: TeamsViewInput?
    var router: TeamsRouterInput?
    weak var output: TeamsModuleOutput?
}

// MARK: - TeamsViewOutput

extension TeamsPresenter: TeamsViewOutput {
    func viewDidLoad() {}
}

// MARK: - TeamsInput

extension TeamsPresenter: TeamsModuleInput {}
