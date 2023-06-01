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
        getInfo()
    }

    func getInfo() {
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
                ProfilePresenter.userInfo = User(name: success.nickname)
                DispatchQueue.main.async {
                    guard let roomID = success.roomID,
                          let roomName = success.roomName
                    else {
                        return
                    }
                    var open = self.view?.viewModel?.openRooms
                    open?.removeAll(where: { it in
                        it.roomID == roomID
                    })

                    self.view?.viewModel = RoomsViewModel(
                        activeRoom: Room(roomID: roomID, name: roomName),
                        openRooms: open ?? []
                    )
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

    func search(str: String?) {
        guard let str else {
            return
        }

        guard let data = view?.viewModel?.openRooms else {
            return
        }

        view?.viewModel = RoomsViewModel(activeRoom: view?.viewModel?.activeRoom, openRooms: sortCustom(searchStr: str, strings: data))
    }

    func select(room: Room, isActive: Bool = false) {
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
    
    private func sortCustom(searchStr: String, strings: [Room]) -> [Room] {
        var indexed_strings: [(Int, UUID)] = []
        for i in 0..<strings.count {
            var counter = 0
            for j in 0..<min(searchStr.count, strings[i].name.count) {
                if (searchStr[j].lowercased() == strings[i].name[j].lowercased()) {
                    counter += 1;
                } else {
                    break;
                }
            }
            indexed_strings.append((counter, strings[i].roomID))
        }
        
        indexed_strings.sort(by: { x, y in
            x.0 > y.0
        })
        
        var array: [Room] = []
        
        for i in 0..<indexed_strings.count {
            if let room =  strings.first(where: { r in
                r.roomID == indexed_strings[i].1
            }) {
                array.append(room)
            }
           
        }
        
        return array
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
