protocol RoomModuleInput: AnyObject {}

protocol RoomModuleOutput: AnyObject {}

final class RoomPresenter {
    // MARK: - Properties

    weak var view: RoomViewInput?
    var router: RoomRouterInput?
    weak var output: RoomModuleOutput?
}

// MARK: - RoomViewOutput

extension RoomPresenter: RoomViewOutput {

    func viewDidLoad() {}

    func save(name: String, isPrivate: Bool) {
        let room = Room(name: name, roomType: isPrivate ? .private : .public)
        router?.showRoomInfo(room: room)
    }

    func cancel() {
        router?.close()
    }
}

// MARK: - RoomInput

extension RoomPresenter: RoomModuleInput {}
