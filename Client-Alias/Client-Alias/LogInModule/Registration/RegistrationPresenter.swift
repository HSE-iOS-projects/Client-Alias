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
}

// MARK: - RegistrationInput

extension RegistrationPresenter: RegistrationModuleInput {}
