protocol AddKeyModuleInput: AnyObject {}

protocol AddKeyModuleOutput: AnyObject {}

final class AddKeyPresenter {
    // MARK: - Properties

    weak var view: AddKeyViewInput?
    var router: AddKeyRouterInput?
    weak var output: AddKeyModuleOutput?
}

// MARK: - AddKeyViewOutput

extension AddKeyPresenter: AddKeyViewOutput {

    func viewDidLoad() {}

    func add(key: String) {
        print(key)
    }
}

// MARK: - AddKeyInput

extension AddKeyPresenter: AddKeyModuleInput {}
