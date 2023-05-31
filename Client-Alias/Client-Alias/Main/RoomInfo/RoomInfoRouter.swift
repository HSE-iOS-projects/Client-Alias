import UIKit

protocol RoomInfoRouterInput {

    func showUserActions(user: String,
                         isAdmin: Bool,
                         addHandler: @escaping () -> Void,
                         adminHandler: @escaping () -> Void?,
                         deleteHandler: @escaping () -> Void?)
    func showTeams(participantID: UUID, teams: [TeamInfo])
    func showMembers(model: MembersModel)
    func showAddTeam(roomId: UUID)
    func showGameSettings()
    func showTeamActions(team: String, deleteHandler: @escaping () -> Void)
    func showAlert(title: String, message: String)
    func showAlert()
//    func showInviteCode(code: String)
}

final class RoomInfoRouter {
    // MARK: - Properties

    weak var view: UIViewController?
}

// MARK: - RoomInfoRouterInput

extension RoomInfoRouter: RoomInfoRouterInput {

    func showUserActions(user: String,
                         isAdmin: Bool,
                         addHandler: @escaping () -> Void,
                         adminHandler: @escaping () -> Void?,
                         deleteHandler: @escaping () -> Void?) {
        let vc = UIAlertController(title: user, message: "", preferredStyle: .actionSheet)
        let addAction = UIAlertAction(title: "Добавить в команду", style: .default) { _ in
            addHandler()
        }
        vc.addAction(addAction)
        
        if !isAdmin {
            let adminAction = UIAlertAction(title: "Сделать администратором", style: .default) { _ in
                adminHandler()
            }
            vc.addAction(adminAction)
            
            let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
                deleteHandler()
            }
            vc.addAction(deleteAction)
        }
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

    func showTeams(participantID: UUID, teams: [TeamInfo]) {
        let vc = TeamsModuleConfigurator().configure(participantID: participantID, teams: teams).view
        vc.sheetPresentationController?.detents = [.medium()]
        view?.present(vc, animated: true)
    }

    func showMembers(model: MembersModel) {
        let vc = MembersModuleConfigurator().configure(model: model).view
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
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController.makeProblemAlert(title: title, message: message, anchoredBarButtonItem: .none)
        view?.present(alert, animated: true, completion: nil)
    }
    
    func showAlert() {
        view?.present(UIAlertController.makeProblemAlert(anchoredBarButtonItem: .none), animated: true, completion: nil)
    }
    
//    func showInviteCode(code: String) {
//        let vc = InviteCodeViewController(text: code)
//        vc.sheetPresentationController?.detents = [.medium()]
//        view?.present(vc, animated: true)
//    }
}
