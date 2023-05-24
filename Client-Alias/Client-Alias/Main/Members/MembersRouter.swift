import UIKit

protocol MembersRouterInput {

    func showUserActions(user: String, addHandler: @escaping () -> Void, deleteHandler: @escaping () -> Void)
}

final class MembersRouter {
    // MARK: - Properties

    weak var view: UIViewController?
}

// MARK: - MembersRouterInput

extension MembersRouter: MembersRouterInput {

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
}
