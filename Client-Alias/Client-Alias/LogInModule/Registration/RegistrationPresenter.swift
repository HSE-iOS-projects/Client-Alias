protocol RegistrationModuleInput: AnyObject {}

protocol RegistrationModuleOutput: AnyObject {}

final class RegistrationPresenter {
    // MARK: - Properties

    weak var view: RegistrationViewInput?
    var router: RegistrationRouterInput?
    weak var output: RegistrationModuleOutput?
}

// MARK: - RegistrationViewOutput

extension RegistrationPresenter: RegistrationViewOutput {
    func viewDidLoad() {}
    
    func logInButtonTapped(name: String, age: String) {
        let name = nameError(text: name)
        let age = nameError(text: age)
        if name != nil || age != nil {
            view?.displayError(
                FormatError(
                    nameError: name,
                    ageError: age
                )
            )
        } else {
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
