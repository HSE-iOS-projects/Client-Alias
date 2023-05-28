import Foundation
protocol RoomsModuleInput: AnyObject {}

protocol RoomsModuleOutput: AnyObject {}

final class RoomsPresenter {
    // MARK: - Properties

    weak var view: RoomsViewInput?
    var router: RoomsRouterInput?
    weak var output: RoomsModuleOutput?
    
    let worker: MainWorker
    
    init(worker: MainWorker) {
        self.worker = worker
    }
}

// MARK: - RoomsViewOutput

extension RoomsPresenter: RoomsViewOutput {

    func viewDidLoad() {
        worker.gellAllRooms { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let success):
                let rooms = createRooms(success)
                DispatchQueue.main.async {
                    self.view?.viewModel = RoomsViewModel(activeRoom: nil, openRooms: rooms)
                }
            case .failure(let failure):
                print(failure)
            }
        }
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
    
    //FIXME: - добавить url
    private func createRooms(_ data: [AllRoomsResponse]) -> [Room] {
        var rooms = [Room]()
        
        for item in data {
            rooms.append(
                Room(
                    roomID: item.roomID,
                    name: item.name,
                    roomType: item.isOpen ? .public : .private,
                    url: "",
                    code: nil
                )
            )
        }
        
        return rooms
    }
}

// MARK: - RoomsInput

extension RoomsPresenter: RoomsModuleInput {}
