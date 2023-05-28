import UIKit

protocol RoomRouterInput {
    func close()
    func showRoomInfo(room: Room)
    func showAlert()
}

final class RoomRouter {
    // MARK: - Properties

    weak var view: UIViewController?
}

// MARK: - RoomRouterInput

extension RoomRouter: RoomRouterInput {

    func close() {
        view?.navigationController?.popViewController(animated: true)
    }

    func showRoomInfo(room: Room) {
        let vc = RoomInfoModuleConfigurator().configure(room: room).view
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func showAlert() {
        view?.present(UIAlertController.makeProblemAlert(anchoredBarButtonItem: .none), animated: true, completion: nil)
    }
}
