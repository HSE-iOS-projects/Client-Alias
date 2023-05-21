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
        let userRooms = UserRooms(activeRoom: activeRoom, openRooms: openRooms)
        view?.update(userRooms: userRooms)
    }

    func add() {
        router?.addKey()
    }
}

// MARK: - RoomsInput

extension RoomsPresenter: RoomsModuleInput {}
