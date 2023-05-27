protocol ResultModuleInput: AnyObject {}

protocol ResultModuleOutput: AnyObject {}

final class ResultPresenter {
    // MARK: - Properties

    weak var view: ResultViewInput?
    var router: ResultRouterInput?
    weak var output: ResultModuleOutput?
    private var result = ResultInfo(
        winner: TeamInfo(name: "Ура победа", result: 30),
        allTeams: [
            TeamInfo(name: "Ура победа", result: 30),
            TeamInfo(name: "Почти смогли", result: 20),
            TeamInfo(name: "Ну зато пытались", result: 10),
        ])
}

// MARK: - ResultViewOutput

extension ResultPresenter: ResultViewOutput {
    func countTeams() -> Int {
        result.allTeams.count
    }
    
    func getTeamInfo(index: Int) -> TeamInfo {
        result.allTeams[index]
    }
    
    func viewDidLoad() {
        view?.showInfo(winner: result.winner.name)
    }
    
}

// MARK: - ResultInput

extension ResultPresenter: ResultModuleInput {}
