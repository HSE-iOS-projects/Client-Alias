import Foundation
protocol RegistrationModuleInput: AnyObject {}

protocol RegistrationModuleOutput: AnyObject {}

final class RegistrationPresenter {
    // MARK: - Properties

    let worker: AuthorizationWorker
    var storage: SecureSettingsKeeper

    weak var view: RegistrationViewInput?
    weak var output: RegistrationModuleOutput?
    var router: RegistrationRouterInput?

    init(worker: AuthorizationWorker, storage: SecureSettingsKeeper) {
        self.worker = worker
        self.storage = storage
    }
}

// MARK: - RegistrationViewOutput

extension RegistrationPresenter: RegistrationViewOutput {
    func viewDidLoad() {}

    func logInButtonTapped(name: String, age: String) {
        let nameErr = nameError(text: name)
        let ageErr = nameError(text: age)
        if nameErr != nil || ageErr != nil {
            view?.displayError(
                FormatError(
                    nameError: nameErr,
                    passwordError: ageErr
                )
            )
        } else {
            worker.register(email: name, password: age) { [weak self] result in
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

    private func nameError(text: String) -> String? {
        if text.isEmpty {
            return "Пусто"
        } else {
            return nil
        }
    }
}

// MARK: - RegistrationInput

extension RegistrationPresenter: RegistrationModuleInput {}
