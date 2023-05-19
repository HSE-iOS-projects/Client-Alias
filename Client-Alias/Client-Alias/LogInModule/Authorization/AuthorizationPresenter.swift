protocol AuthorizationModuleInput: AnyObject {}

protocol AuthorizationModuleOutput: AnyObject {}

final class AuthorizationPresenter {
    // MARK: - Properties

    weak var view: AuthorizationViewInput?
    var router: AuthorizationRouterInput?
    weak var output: AuthorizationModuleOutput?
}

// MARK: - AuthorizationViewOutput

extension AuthorizationPresenter: AuthorizationViewOutput {

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
