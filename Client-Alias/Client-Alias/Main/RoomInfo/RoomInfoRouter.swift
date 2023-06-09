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
    func showGameSettings(roomID: UUID)
    func showTeamActions(team: String, deleteHandler: @escaping () -> Void)
    func showAlert(title: String, message: String)
    func showAlert()
    func initCoordinator(room: PlayRoundInfo)
    func showRoomActions(info: String, changeHandler: @escaping () -> Void)
}

final class RoomInfoRouter {
    // MARK: - Properties

    weak var view: UIViewController?
    var w: GameCoordinator?
}

// MARK: - RoomInfoRouterInput

extension RoomInfoRouter: RoomInfoRouterInput {
    func initCoordinator(room: PlayRoundInfo) {
        w = GameCoordinator(navigation: view?.navigationController, room: room)
        WebSocketManagerImpl.shared.addObserver(w!)
    }

    func showUserActions(user: String,
                         isAdmin: Bool,
                         addHandler: @escaping () -> Void,
                         adminHandler: @escaping () -> Void?,
                         deleteHandler: @escaping () -> Void?)
    {
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

    func showRoomActions(info: String, changeHandler: @escaping () -> Void) {
        let vc = UIAlertController(title: "Настройки комнаты", message: "", preferredStyle: .actionSheet)

        let deleteAction = UIAlertAction(title: info, style: .destructive) { _ in
            changeHandler()
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

    func showGameSettings(roomID: UUID) {
        let vc = GameSettingsModuleConfigurator().configure(roomID: roomID).view
        view?.navigationController?.pushViewController(vc, animated: true)
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController.makeProblemAlert(title: title, message: message, anchoredBarButtonItem: .none)
        view?.present(alert, animated: true, completion: nil)
    }

    func showAlert() {
        view?.present(UIAlertController.makeProblemAlert(anchoredBarButtonItem: .none), animated: true, completion: nil)
    }
}
