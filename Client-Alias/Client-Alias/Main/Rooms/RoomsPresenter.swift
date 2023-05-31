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
        view?.viewModel = RoomsViewModel(openRooms: [])
        worker.getAllRooms { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let success):
                let rooms = createRooms(success)
                DispatchQueue.main.async {
                    self.view?.viewModel? = RoomsViewModel(openRooms: rooms)
                }
            case .failure(let failure):
                print(failure)
            }
        }
        
        worker.getMyInfo { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let success):
                
                DispatchQueue.main.async {
                    guard let roomID = success.roomID,
                          let roomName = success.roomName else {
                        return
                    }
                    var open = self.view?.viewModel?.openRooms
                    open?.removeAll(where: { it in
                        it.roomID == roomID
                    })
                    ProfilePresenter.userInfo = User(name: success.nickname, playedGames: 0, winGames: 0)
                    self.view?.viewModel = RoomsViewModel(
                        activeRoom: Room(roomID: roomID, name: roomName),
                        openRooms: open ?? [])
                   
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

    func select(room: Room, isActive: Bool = false) {
//        self.router?.showRoomInfo(room: room)
        if !isActive {
            worker.joinRoom(request: JoinRoomRequest(roomID: room.roomID, inviteCode: nil)) { [weak self] result in
                guard let self = self else {
                    return
                }
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self.router?.showRoomInfo(room: room)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            router?.showRoomInfo(room: room)
        }
    }
    
    private func createRooms(_ data: [AllRoomsResponse]) -> [Room] {
        var rooms = [Room]()
        
        for item in data {
            rooms.append(
                Room(
                    roomID: item.roomID,
                    name: item.name,
                    roomType: item.isOpen ? .public : .private,
                    url: item.url,
                    code: nil,
                    isAdmin: item.isAdmin
                )
            )
        }
        
        return rooms
    }
}

// MARK: - RoomsInput

extension RoomsPresenter: RoomsModuleInput {}
