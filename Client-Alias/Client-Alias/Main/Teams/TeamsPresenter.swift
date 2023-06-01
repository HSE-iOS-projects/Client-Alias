import Foundation
protocol TeamsModuleInput: AnyObject {}

protocol TeamsModuleOutput: AnyObject {}

final class TeamsPresenter {
    // MARK: - Properties

    weak var view: TeamsViewInput?
    var router: TeamsRouterInput?
    weak var output: TeamsModuleOutput?

    let teams: [TeamInfo]
    let participantID: UUID
    let worker: MainWorker

    private var changed: Bool = false

    init(participantID: UUID, teams: [TeamInfo], worker: MainWorker) {
        self.participantID = participantID
        self.teams = teams
        self.worker = worker
    }
}

// MARK: - TeamsViewOutput

extension TeamsPresenter: TeamsViewOutput {
    func viewDidLoad() {}

    func getCount() -> Int {
        teams.count + 1
    }

    func getTeam(index: Int) -> String {
        teams[index].name
    }

    func hasChanges() -> Bool {
        changed
    }

    func getParticipant() -> UUID {
        participantID
    }

    func selectTeam(index: Int) {
        guard let id = teams[index].teamID else {
            return
        }
        worker.addToTeam(request: AddUserToTeamRequest(userID: participantID, teamID: id)) { [weak self] result in
            switch result {
            case .success:
                guard let self = self else {
                    return
                }
                DispatchQueue.main.async {
                    self.changed = true
                    self.router?.closeView()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - TeamsInput

extension TeamsPresenter: TeamsModuleInput {}
