protocol ProfileModuleInput: AnyObject {}

protocol ProfileModuleOutput: AnyObject {}

final class ProfilePresenter {
    // MARK: - Properties

    weak var view: ProfileViewInput?
    var router: ProfileRouterInput?
    weak var output: ProfileModuleOutput?
    
    static var userInfo = User(name: "", playedGames: 0, winGames: 0)
}

// MARK: - ProfileViewOutput

extension ProfilePresenter: ProfileViewOutput {

    func viewDidLoad() {
        view?.update(user: ProfilePresenter.userInfo)
    }

    func logout() {
        print("logout")
    }
}

// MARK: - ProfileInput

extension ProfilePresenter: ProfileModuleInput {}
