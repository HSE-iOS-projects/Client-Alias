import UIKit

protocol RoomsRouterInput {

    func showRoom()
    func addKey()
    func showRoomInfo(room: Room)
}

final class RoomsRouter {
    // MARK: - Properties

    weak var view: UIViewController?
    

}

// MARK: - RoomsRouterInput

extension RoomsRouter: RoomsRouterInput {


    func showRoom() {
        let vc = RoomModuleConfigurator().configure().view
        view?.navigationController?.pushViewController(vc, animated: true)
    }

    func addKey() {
        let vc = AddKeyModuleConfigurator().configure().view
        vc.sheetPresentationController?.detents = [.medium()]
    
        
        view?.present(vc, animated: true)
    }

    func showRoomInfo(room: Room) {
        let vc = RoomInfoModuleConfigurator().configure(room: room).view
        view?.navigationController?.pushViewController(vc, animated: true)
    }
}
