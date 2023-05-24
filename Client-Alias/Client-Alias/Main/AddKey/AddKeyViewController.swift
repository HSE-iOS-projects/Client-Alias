import UIKit

protocol AddKeyViewInput: AnyObject {}

protocol AddKeyViewOutput: AnyObject {
    func viewDidLoad()
}

final class AddKeyViewController: UIViewController {
    // MARK: - Outlets

    private lazy var addButton: UIButton = {
        let addButton = UIButton()
        addButton.layer.cornerRadius = 15
        addButton.backgroundColor = UIColor(red: 58 / 255, green: 81 / 255, blue: 151 / 255, alpha: 1)
        addButton.setTitle("Добавить ключ", for: .normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        return addButton
    }()

    // MARK: - Properties

    var output: AddKeyViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()

        view.backgroundColor = .black
        
        setupUI()
    }

    // MARK: - Actions

    @objc func add() {

    }

    // MARK: - Setup

    private func setupUI() {
        view.addSubview(addButton)

        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 48),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupLocalization() {}
}

// MARK: - TroikaServiceViewInput

extension AddKeyViewController: AddKeyViewInput {}
