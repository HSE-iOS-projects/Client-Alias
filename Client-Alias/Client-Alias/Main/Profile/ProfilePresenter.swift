protocol ProfileModuleInput: AnyObject {}

protocol ProfileModuleOutput: AnyObject {}

final class ProfilePresenter {
    // MARK: - Properties

    weak var view: ProfileViewInput?
    var router: ProfileRouterInput?
    weak var output: ProfileModuleOutput?
}

// MARK: - ProfileViewOutput

extension ProfilePresenter: ProfileViewOutput {

    func viewDidLoad() {
        let user = User(name: "Fedor", playedGames: 12, winGames: 10)
        view?.update(user: user)
    }

    func logout() {
        print("logout")
    }
}

// MARK: - ProfileInput

extension ProfilePresenter: ProfileModuleInput {}
