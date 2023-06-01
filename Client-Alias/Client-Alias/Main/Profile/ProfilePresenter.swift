import Foundation
protocol ProfileModuleInput: AnyObject {}

protocol ProfileModuleOutput: AnyObject {}

final class ProfilePresenter {
    // MARK: - Properties

    weak var view: ProfileViewInput?
    var router: ProfileRouterInput?
    weak var output: ProfileModuleOutput?
    
    static var userInfo = User(name: "")
    
    let worker: MainWorker
    var storage: SecureSettingsKeeper
    
    init(worker: MainWorker, storage: SecureSettingsKeeper) {
        self.worker = worker
        self.storage = storage
    }
}

// MARK: - ProfileViewOutput

extension ProfilePresenter: ProfileViewOutput {

    func viewDidLoad() {
        view?.update(user: ProfilePresenter.userInfo)
    }

    func logout() {
        router?.openAuthView()
        storage.clear()
    }
    
    func deleteProfile() {
        worker.deleteUser { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success:
                self.storage.clear()
                DispatchQueue.main.async {
                    self.router?.openAuthView()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - ProfileInput

extension ProfilePresenter: ProfileModuleInput {}
