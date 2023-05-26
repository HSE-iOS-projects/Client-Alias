protocol RoomInfoModuleInput: AnyObject {}

protocol RoomInfoModuleOutput: AnyObject {}

final class RoomInfoPresenter {
    // MARK: - Properties

    weak var view: RoomInfoViewInput?
    var router: RoomInfoRouterInput?
    weak var output: RoomInfoModuleOutput?
    let room: Room

    init(room: Room) {
        self.room = room
    }
}

// MARK: - RoomInfoViewOutput

extension RoomInfoPresenter: RoomInfoViewOutput {

    func viewDidLoad() {
        view?.viewModel = RoomInfoViewModel(room: room)
    }

    func select(user: String) {
        router?.showUserActions(user: user, addHandler: { [weak self] in
            self?.router?.showTeams()
        }, adminHandler: {

        }, deleteHandler: {
            print("1")
        })
    }

    func select(team: String) {
        router?.showMembers()
    }

    func addTeam() {
        router?.showAddTeam()
    }

    func start() {
        router?.showGameSettings()
    }
}

// MARK: - RoomInfoInput

extension RoomInfoPresenter: RoomInfoModuleInput {}
