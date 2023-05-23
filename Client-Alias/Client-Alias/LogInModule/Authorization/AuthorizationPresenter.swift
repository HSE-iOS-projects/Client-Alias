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
    
    func logInButtonTapped(name: String, password: String) {
        let name = nameError(text: name)
        let password = nameError(text: password)
        if name != nil || password != nil {
            view?.displayError(
                FormatError(
                    nameError: name,
                    ageError: password
                )
            )
        } else {
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
