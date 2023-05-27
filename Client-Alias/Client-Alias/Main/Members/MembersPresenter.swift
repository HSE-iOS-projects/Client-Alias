protocol MembersModuleInput: AnyObject {}

protocol MembersModuleOutput: AnyObject {}

final class MembersPresenter {
    // MARK: - Properties

    weak var view: MembersViewInput?
    var router: MembersRouterInput?
    weak var output: MembersModuleOutput?
}

// MARK: - MembersViewOutput

extension MembersPresenter: MembersViewOutput {

    func viewDidLoad() {}

    func select(user: String) {
        router?.showUserActions(user: user, addHandler: {}, adminHandler: {}, deleteHandler: {})
    }
}

// MARK: - MembersInput

extension MembersPresenter: MembersModuleInput {}
