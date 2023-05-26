protocol GameSettingsModuleInput: AnyObject {}

protocol GameSettingsModuleOutput: AnyObject {}

final class GameSettingsPresenter {
    // MARK: - Properties

    weak var view: GameSettingsViewInput?
    var router: GameSettingsRouterInput?
    weak var output: GameSettingsModuleOutput?
}

// MARK: - GameSettingsViewOutput

extension GameSettingsPresenter: GameSettingsViewOutput {
    func viewDidLoad() {}

    func continueGame() {
        print("continueGame")
    }
}

// MARK: - GameSettingsInput

extension GameSettingsPresenter: GameSettingsModuleInput {}
