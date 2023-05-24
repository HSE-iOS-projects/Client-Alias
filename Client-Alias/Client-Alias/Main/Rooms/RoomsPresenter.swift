protocol RoomsModuleInput: AnyObject {}

protocol RoomsModuleOutput: AnyObject {}

final class RoomsPresenter {
    // MARK: - Properties

    weak var view: RoomsViewInput?
    var router: RoomsRouterInput?
    weak var output: RoomsModuleOutput?
}

// MARK: - RoomsViewOutput

extension RoomsPresenter: RoomsViewOutput {

    func viewDidLoad() {
        let activeRoom = Room(name: "Моя комната", roomType: .private)
        let openRooms = [Room(name: "Моя комната 2", roomType: .private),
                         Room(name: "Моя комната 3", roomType: .public),
                         Room(name: "Моя комната 4", roomType: .private)]
        view?.viewModel = RoomsViewModel(activeRoom: activeRoom, openRooms: openRooms)
    }

    func add() {
        router?.showRoom()
    }

    func addKey() {
        router?.addKey()
    }

    func select(room: Room) {
        router?.showRoomInfo(room: room)
    }
}

// MARK: - RoomsInput

extension RoomsPresenter: RoomsModuleInput {}
