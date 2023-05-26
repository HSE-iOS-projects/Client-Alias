protocol AddTeamModuleInput: AnyObject {}

protocol AddTeamModuleOutput: AnyObject {}

final class AddTeamPresenter {
    // MARK: - Properties

    weak var view: AddTeamViewInput?
    var router: AddTeamRouterInput?
    weak var output: AddTeamModuleOutput?
}

// MARK: - AddTeamViewOutput

extension AddTeamPresenter: AddTeamViewOutput {
    func viewDidLoad() {}

    func add(team: String) {
        print(team)
    }
}

// MARK: - AddTeamInput

extension AddTeamPresenter: AddTeamModuleInput {}
