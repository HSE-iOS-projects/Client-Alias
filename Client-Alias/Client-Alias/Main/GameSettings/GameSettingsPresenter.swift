import Foundation
protocol GameSettingsModuleInput: AnyObject {}

protocol GameSettingsModuleOutput: AnyObject {}

final class GameSettingsPresenter {
    // MARK: - Properties

    weak var view: GameSettingsViewInput?
    var router: GameSettingsRouterInput?
    weak var output: GameSettingsModuleOutput?
    
    let worker: MainWorker

    init(worker: MainWorker) {
        self.worker = worker
    }
}

// MARK: - GameSettingsViewOutput

extension GameSettingsPresenter: GameSettingsViewOutput {
    func viewDidLoad() {}

    func continueGame(roundNum: String) {
        let roundEr = roundError(text: roundNum)
        if roundEr == nil {
            worker.startGame(request: StartGameRequest(numberOfRounds: Int(roundNum) ?? 0), completion: { [weak self] result in
                guard let self = self else {
                    return
                }
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self.router?.openGame()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        } else {
            view?.showError(error: roundEr ?? "")
        }
        
    }
    
    private func roundError(text: String) -> String? {
        if text.isEmpty {
            return "Пусто"
        } else if !text.isInt() {
            return "Неправильный формат"
        } else {
            return nil
        }
    }
}

// MARK: - GameSettingsInput

extension GameSettingsPresenter: GameSettingsModuleInput {}
