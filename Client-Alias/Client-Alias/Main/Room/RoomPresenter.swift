protocol RoomModuleInput: AnyObject {}

protocol RoomModuleOutput: AnyObject {}

final class RoomPresenter {
    // MARK: - Properties

    weak var view: RoomViewInput?
    var router: RoomRouterInput?
    weak var output: RoomModuleOutput?

    private var code: String?
}

// MARK: - RoomViewOutput

extension RoomPresenter: RoomViewOutput {

    func viewDidLoad() {}

    func save(name: String, isPrivate: Bool, url: String) {
        let room = Room(name: name,
                        roomType: isPrivate ? .private : .public,
                        url: url,
                        code: code)
        router?.showRoomInfo(room: room)
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
