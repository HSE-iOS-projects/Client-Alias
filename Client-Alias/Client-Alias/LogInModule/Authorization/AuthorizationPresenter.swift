protocol AuthorizationModuleInput: AnyObject {}

protocol AuthorizationModuleOutput: AnyObject {}

final class AuthorizationPresenter {
    // MARK: - Properties

    let worker: AuthorizationWorker

    weak var view: AuthorizationViewInput?
    weak var output: AuthorizationModuleOutput?
    var router: AuthorizationRouterInput?


    init(worker: AuthorizationWorker) {
        self.worker = worker
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
            worker.login(email: name, password: password) { result in
                print(result)
            }
            // TODO: - сохранение кейчейн, показ следующего экрана
            router?.openMainScreen()
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
