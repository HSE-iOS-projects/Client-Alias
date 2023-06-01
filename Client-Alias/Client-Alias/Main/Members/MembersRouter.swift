import UIKit

protocol MembersRouterInput {
    func showUserActions(user: String,
                         isAdmin: Bool,
                         addHandler: @escaping () -> Void,
                         adminHandler: @escaping () -> Void?,
                         deleteHandler: @escaping () -> Void?)

    func showTeams(participantID: UUID, teams: [TeamInfo])
}

final class MembersRouter {
    // MARK: - Properties

    weak var view: UIViewController?
}

// MARK: - MembersRouterInput

extension MembersRouter: MembersRouterInput {
    func showUserActions(user: String,
                         isAdmin: Bool,
                         addHandler: @escaping () -> Void,
                         adminHandler: @escaping () -> Void?,
                         deleteHandler: @escaping () -> Void?)
    {
        let vc = UIAlertController(title: user, message: "", preferredStyle: .actionSheet)
        let addAction = UIAlertAction(title: "Изменить команду", style: .default) { _ in
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

    func showTeams(participantID: UUID, teams: [TeamInfo]) {
        let vc = TeamsModuleConfigurator().configure(participantID: participantID, teams: teams).view
        vc.sheetPresentationController?.detents = [.medium()]
        view?.present(vc, animated: true)
    }
}
