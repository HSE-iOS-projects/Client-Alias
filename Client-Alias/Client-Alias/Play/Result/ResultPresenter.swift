protocol ResultModuleInput: AnyObject {}

protocol ResultModuleOutput: AnyObject {}

final class ResultPresenter {
    // MARK: - Properties

    weak var view: ResultViewInput?
    var router: ResultRouterInput?
    weak var output: ResultModuleOutput?
    private var result = ResultInfo(
        winner: TeamResultInfo(name: "Ура победа", result: 30),
        allTeams: [
            TeamResultInfo(name: "Ура победа", result: 30),
            TeamResultInfo(name: "Почти смогли", result: 20),
            TeamResultInfo(name: "Ну зато пытались", result: 10),
        ])
}

// MARK: - ResultViewOutput

extension ResultPresenter: ResultViewOutput {
    func countTeams() -> Int {
        result.allTeams.count
    }
    
    func getTeamInfo(index: Int) -> TeamResultInfo {
        result.allTeams[index]
    }
    
    func viewDidLoad() {
        view?.showInfo(winner: result.winner.name)
    }
    
}

// MARK: - ResultInput

extension ResultPresenter: ResultModuleInput {}
