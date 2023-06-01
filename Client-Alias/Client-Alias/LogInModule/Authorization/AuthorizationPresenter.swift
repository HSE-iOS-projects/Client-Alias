import Foundation
protocol AuthorizationModuleInput: AnyObject {}

protocol AuthorizationModuleOutput: AnyObject {}

final class AuthorizationPresenter {
    // MARK: - Properties

    let worker: AuthorizationWorker

    weak var view: AuthorizationViewInput?
    weak var output: AuthorizationModuleOutput?
    var router: AuthorizationRouterInput?
    var storage: SecureSettingsKeeper

    init(worker: AuthorizationWorker, storage: SecureSettingsKeeper) {
        self.worker = worker
        self.storage = storage
    }
}

// MARK: - AuthorizationViewOutput

extension AuthorizationPresenter: AuthorizationViewOutput {
    func viewDidLoad() {}

    func logInButtonTapped(name: String, password: String) {
        let nameErr = nameError(text: name)
        let passwordErr = nameError(text: password)
        if nameErr != nil || passwordErr != nil {
            view?.displayError(
                FormatError(
                    nameError: nameErr,
                    passwordError: passwordErr
                )
            )
        } else {
            worker.login(email: name, password: password) { [weak self] result in
                guard let self = self else {
                    return
                }
                switch result {
                case .success(let success):
                    self.storage.authToken = success.token
                    DispatchQueue.main.async {
                        self.router?.openMainScreen()
                    }
                    WebSocketManagerImpl.shared.connect()
                case .failure(let failure):
                    DispatchQueue.main.async {
                        self.router?.showAlert()
                    }
                    print(failure)
                }
            }
        }
    }

    func openRegistration() {
        router?.openRegistrationViewController()
    }

    private func nameError(text: String) -> String? {
        if text.isEmpty {
            return "Пусто"
        } else {
            return nil
        }
    }
}

// MARK: - AuthorizationInput

extension AuthorizationPresenter: AuthorizationModuleInput {}
