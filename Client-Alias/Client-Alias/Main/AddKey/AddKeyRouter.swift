import UIKit

protocol AddKeyRouterInput {
    func showAlert()
    func showRoomInfo(room: Room)
    func closeView()
}

final class AddKeyRouter {
    // MARK: - Properties

    weak var view: UIViewController?
}

// MARK: - AddKeyRouterInput

extension AddKeyRouter: AddKeyRouterInput {
    func showAlert() {
        view?.present(UIAlertController.makeProblemAlert(anchoredBarButtonItem: .none), animated: true, completion: nil)
    }
    
    func showRoomInfo(room: Room) {
        let vc = RoomInfoModuleConfigurator().configure(room: room).view
        
       
        view?.dismiss(animated: true)
    }
    
    func closeView() {
        view?.dismiss(animated: true)
    }
}
