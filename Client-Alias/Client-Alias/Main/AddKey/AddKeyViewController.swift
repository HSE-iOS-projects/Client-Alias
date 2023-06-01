import UIKit

protocol AddKeyViewInput: AnyObject {}

protocol AddKeyViewOutput: AnyObject {
    func viewDidLoad()
    func add(key: String)
    func getRoom() -> Room?
}

final class AddKeyViewController: UIViewController {
    // MARK: - Outlets

    private lazy var keyLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .label
        titleLabel.text = "Ключ"
        titleLabel.font = .systemFont(ofSize: 19)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()

    private lazy var keyTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .label
        textField.tintColor = .gray
//        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 15
        textField.setLeftPaddingPoints(15)
        textField.backgroundColor = UIColor.ColorPalette.secondSecondBackgroundColor
//        textField.backgroundColor = UIColor(red: 28 / 255, green: 28 / 255, blue: 30 / 255, alpha: 1)
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

        view.backgroundColor = .secondarySystemBackground
        self.modalPresentationStyle = .pageSheet
        self.isModalInPresentation = false
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let room = output?.getRoom(),
           let firstVC = presentingViewController?.children.last?.children.first as? RoomsViewController {
            DispatchQueue.main.async {
                firstVC.output?.select(room: room, isActive: true)
            }
        }
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
            keyLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            keyLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            keyLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),

            keyTextField.topAnchor.constraint(equalTo: keyLabel.bottomAnchor, constant: 20),
            keyTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            keyTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            keyTextField.heightAnchor.constraint(equalToConstant: 50),

            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 48),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15)
        ])
    }

    private func setupLocalization() {}
}

// MARK: - TroikaServiceViewInput

extension AddKeyViewController: AddKeyViewInput {}
