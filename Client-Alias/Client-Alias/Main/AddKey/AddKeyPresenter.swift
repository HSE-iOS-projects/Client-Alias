import Foundation
protocol AddKeyModuleInput: AnyObject {}

protocol AddKeyModuleOutput: AnyObject {}

final class AddKeyPresenter {
    // MARK: - Properties

    weak var view: AddKeyViewInput?
    var router: AddKeyRouterInput?
    weak var output: AddKeyModuleOutput?
    var room: Room?

    let worker: MainWorker
    init(worker: MainWorker) {
        self.worker = worker
    }
}

// MARK: - AddKeyViewOutput

extension AddKeyPresenter: AddKeyViewOutput {
    func viewDidLoad() {}

    func add(key: String) {
        worker.joinRoom(request: JoinRoomRequest(roomID: nil, inviteCode: key)) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self.room = Room(
                        roomID: success.id,
                        name: success.name,
                        roomType: .private,
                        url: success.url,
                        code: success.key,
                        isAdmin: success.isAdmin
                    )
                    self.router?.closeView()
                }
            case .failure(let failure):
                DispatchQueue.main.async {
                    self.router?.showAlert()
                }
                print(failure)
            }
        }
        print(key)
    }

    func getRoom() -> Room? {
        room
    }
}

// MARK: - AddKeyInput

extension AddKeyPresenter: AddKeyModuleInput {}
