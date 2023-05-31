import Foundation
protocol RoomModuleInput: AnyObject {}

protocol RoomModuleOutput: AnyObject {}

final class RoomPresenter {
    // MARK: - Properties
    


    weak var view: RoomViewInput?
    var router: RoomRouterInput?
    weak var output: RoomModuleOutput?

    private var code: String?
    
    let worker: MainWorker
    init(worker: MainWorker) {
        self.worker = worker
    }
}

// MARK: - RoomViewOutput

extension RoomPresenter: RoomViewOutput {

    func viewDidLoad() {}

    func save(name: String, isPrivate: Bool, url: String) {
//        let room = Room(name: name,
//                        roomType: isPrivate ? .private : .public,
//                        url: url,
//                        code: code)
//
//        // FIXME: - Передать и показать код, но скорее не здесь
        
        
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
                worker.joinRoom(request: req) { [weak self] result  in
                    guard let self = self else {
                        return
                    }
                    switch result {
                    case .success:
                        DispatchQueue.main.async {
                            self.router?.showRoomInfo(room:
                                                        Room(
                                                            roomID: success.roomID,
                                                            name: name,
                                                            roomType: isPrivate ? .private : .public,
                                                            url: url,
                                                            code: success.inviteCode,
                                                            isAdmin: true
                                                        ))
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

    func cancel() {
        router?.close()
    }

    func generateCode() -> String {
        let code = String.random(count: 20)
        self.code = code
        return code
    }
}

// MARK: - RoomInput

extension RoomPresenter: RoomModuleInput {}

private extension String {

    static let symbols = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

    static func random(count: Int) -> String {
        var result = ""
        for _ in 0..<count {
            if let randomElement = Self.symbols.randomElement() {
                result += String(randomElement)
            }
        }
        return result
    }
}
