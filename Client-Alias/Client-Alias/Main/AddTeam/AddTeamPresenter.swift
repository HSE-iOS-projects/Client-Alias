import Foundation
protocol AddTeamModuleInput: AnyObject {}

protocol AddTeamModuleOutput: AnyObject {}

final class AddTeamPresenter {
    // MARK: - Properties

    weak var view: AddTeamViewInput?
    var router: AddTeamRouterInput?
    weak var output: AddTeamModuleOutput?
    
    let worker: MainWorker
    let roomID: UUID
    
    init(worker: MainWorker, roomID: UUID) {
        self.worker = worker
        self.roomID = roomID
    }
}

// MARK: - AddTeamViewOutput

extension AddTeamPresenter: AddTeamViewOutput {
    func viewDidLoad() {}

    func add(team: String) {
        worker.createTeam(request: TeamRequest(roomID: roomID, name: team)) { [weak self] result in
            switch result {
            case .success:
                guard let self = self else {
                    return
                }
                DispatchQueue.main.async {
                    self.router?.closeViewController()
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func closeView() {
        router?.closeViewController()
    }
}

// MARK: - AddTeamInput

extension AddTeamPresenter: AddTeamModuleInput {}
