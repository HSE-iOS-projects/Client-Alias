import UIKit

protocol RegistrationViewInput: AnyObject {}

protocol RegistrationViewOutput: AnyObject {
    func viewDidLoad()
}

final class RegistrationViewController: UIViewController {
    // MARK: - Outlets

    // MARK: - Properties

    var output: RegistrationViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
        view.backgroundColor = .red
    }

    // MARK: - Actions

    // MARK: - Setup

    private func setupUI() {}

    private func setupLocalization() {}
}

// MARK: - TroikaServiceViewInput

extension RegistrationViewController: RegistrationViewInput {}
