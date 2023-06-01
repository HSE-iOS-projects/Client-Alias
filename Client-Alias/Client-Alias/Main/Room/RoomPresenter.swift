import Foundation
protocol RoomModuleInput: AnyObject {}

protocol RoomModuleOutput: AnyObject {}

final class RoomPresenter {
    // MARK: - Properties

    weak var view: RoomViewInput?
    var router: RoomRouterInput?
    weak var output: RoomModuleOutput?

    private var code: String?

    var room: Room?
    let worker: MainWorker
    init(worker: MainWorker) {
        self.worker = worker
    }
}

// MARK: - RoomViewOutput

extension RoomPresenter: RoomViewOutput {
    func viewDidLoad() {}

    func save(name: String, isPrivate: Bool, url: String) {
        worker.createRoom(request: RoomRequest(name: name, url: url, is_open: !isPrivate)) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let success):
                var req: JoinRoomRequest
                if isPrivate {
                    req = JoinRoomRequest(roomID: nil, inviteCode: success.inviteCode)
                } else {
                    req = JoinRoomRequest(roomID: success.roomID, inviteCode: nil)
                }
                worker.joinRoom(request: req) { [weak self] result in
                    guard let self = self else {
                        return
                    }
                    switch result {
                    case .success:
                        DispatchQueue.main.async {
                            self.room = Room(
                                roomID: success.roomID,
                                name: name,
                                roomType: isPrivate ? .private : .public,
                                url: url,
                                code: success.inviteCode,
                                isAdmin: true
                            )
                            self.router?.closeView()
                        }
                    case .failure(let failure):
                        print(failure)
                    }
                }

            case .failure(let failure):
                DispatchQueue.main.async {
                    self.router?.showAlert()
                }
                print(failure)
            }
        }
    }

    func getRoom() -> Room? {
        room
    }

    func cancel() {
        router?.closeView()
    }
}

// MARK: - RoomInput

extension RoomPresenter: RoomModuleInput {}
