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
    
    func logInButtonTapped(name: String, age: String) {
        let nameErr = nameError(text: name)
        let ageErr = nameError(text: age)
        if nameErr != nil || ageErr != nil {
            view?.displayError(
                FormatError(
                    nameError: nameErr,
                    ageError: ageErr
                )
            )
        } else {
            worker.login(email: name, password: age) { result in
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
