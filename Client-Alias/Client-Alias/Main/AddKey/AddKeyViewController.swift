import UIKit

protocol AddKeyViewInput: AnyObject {}

protocol AddKeyViewOutput: AnyObject {
    func viewDidLoad()
    func add(key: String)
}

final class AddKeyViewController: UIViewController {
    // MARK: - Outlets

    private lazy var keyLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .gray
        titleLabel.text = "Ключ"
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()

    private lazy var keyTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(red: 28 / 255, green: 28 / 255, blue: 30 / 255, alpha: 1)
        textField.placeholder = "Ключ"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

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
        guard let key = keyTextField.text, !key.isEmpty else {
            return
        }
        output?.add(key: key)
    }

    // MARK: - Setup

    private func setupUI() {
        view.addSubview(keyLabel)
        view.addSubview(keyTextField)
        view.addSubview(addButton)

        NSLayoutConstraint.activate([
            keyLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            keyLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            keyLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            keyTextField.topAnchor.constraint(equalTo: keyLabel.bottomAnchor, constant: 16),
            keyTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            keyTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            keyTextField.heightAnchor.constraint(equalToConstant: 32),

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
