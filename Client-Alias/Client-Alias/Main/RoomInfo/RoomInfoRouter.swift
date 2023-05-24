import UIKit

protocol RoomInfoRouterInput {

    func showUserActions(user: String, addHandler: @escaping () -> Void, deleteHandler: @escaping () -> Void)
    func showTeams()
    func showMembers()
    func showAddTeam()
}

final class RoomInfoRouter {
    // MARK: - Properties

    weak var view: UIViewController?
}

// MARK: - RoomInfoRouterInput

extension RoomInfoRouter: RoomInfoRouterInput {

    func showUserActions(user: String, addHandler: @escaping () -> Void, deleteHandler: @escaping () -> Void) {
        let vc = UIAlertController(title: user, message: "", preferredStyle: .actionSheet)
        let addAction = UIAlertAction(title: "Изменить команды", style: .default) { _ in
            addHandler()
        }
        vc.addAction(addAction)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            deleteHandler()
        }
        vc.addAction(deleteAction)
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        vc.addAction(cancelAction)
        view?.present(vc, animated: true)
    }

    func showTeams() {
        let vc = TeamsModuleConfigurator().configure().view
        vc.sheetPresentationController?.detents = [.medium()]
        view?.present(vc, animated: true)
    }

    func showMembers() {
        let vc = MembersModuleConfigurator().configure().view
        view?.navigationController?.pushViewController(vc, animated: true)
    }

    func showAddTeam() {
        let vc = AddTeamModuleConfigurator().configure().view
        vc.sheetPresentationController?.detents = [.medium()]
        view?.present(vc, animated: true)
    }
}
