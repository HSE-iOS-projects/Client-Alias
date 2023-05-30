import UIKit

protocol RoomInfoRouterInput {

    func showUserActions(user: String,
                         addHandler: @escaping () -> Void,
                         adminHandler: @escaping () -> Void,
                         deleteHandler: @escaping () -> Void)
    func showTeams()
    func showMembers()
    func showAddTeam(roomId: UUID)
    func showGameSettings()
    func showTeamActions(team: String, deleteHandler: @escaping () -> Void)
//    func showInviteCode(code: String)
}

final class RoomInfoRouter {
    // MARK: - Properties

    weak var view: UIViewController?
}

// MARK: - RoomInfoRouterInput

extension RoomInfoRouter: RoomInfoRouterInput {

    func showUserActions(user: String,
                         addHandler: @escaping () -> Void,
                         adminHandler: @escaping () -> Void,
                         deleteHandler: @escaping () -> Void) {
        let vc = UIAlertController(title: user, message: "", preferredStyle: .actionSheet)
        let addAction = UIAlertAction(title: "Изменить команды", style: .default) { _ in
            addHandler()
        }
        vc.addAction(addAction)
        
        let adminAction = UIAlertAction(title: "Сделать администратором", style: .default) { _ in
            adminHandler()
        }
        vc.addAction(adminAction)
        
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            deleteHandler()
        }
        vc.addAction(deleteAction)
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        vc.addAction(cancelAction)
        view?.present(vc, animated: true)
    }
    
    func showTeamActions(team: String, deleteHandler: @escaping () -> Void) {
        let vc = UIAlertController(title: team, message: "", preferredStyle: .actionSheet)
        
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

    func showAddTeam(roomId: UUID) {
        let vc = AddTeamModuleConfigurator().configure(roomId: roomId).view
        vc.sheetPresentationController?.detents = [.medium()]
        view?.present(vc, animated: true)
    }

    func showGameSettings() {
        let vc = GameSettingsModuleConfigurator().configure().view
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
//    func showInviteCode(code: String) {
//        let vc = InviteCodeViewController(text: code)
//        vc.sheetPresentationController?.detents = [.medium()]
//        view?.present(vc, animated: true)
//    }
}
