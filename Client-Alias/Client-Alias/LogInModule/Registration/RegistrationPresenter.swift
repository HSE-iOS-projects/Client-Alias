protocol RegistrationModuleInput: AnyObject {}

protocol RegistrationModuleOutput: AnyObject {}

final class RegistrationPresenter {
    // MARK: - Properties


    let worker: AuthorizationWorker

    weak var view: RegistrationViewInput?
    weak var output: RegistrationModuleOutput?
    var router: RegistrationRouterInput?

    init(worker: AuthorizationWorker) {
        self.worker = worker
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
                    ageError: ageErr
                )
            )
        } else {
            worker.register(email: name, password: age) { result in
                print(result)
            }
            // TODO: - сохранение кейчейн, показ следующего экрана
            router?.openMainScreen()
        }
    }
    
    
    private func nameError(text: String) -> String? {
        if text.isEmpty {
            return "Пусто"
        } else {
            return nil
        }
    }
    
    
    func openPreviousScreen() {
        router?.openPreviousScreen()
    }
}

// MARK: - RegistrationInput

extension RegistrationPresenter: RegistrationModuleInput {}
