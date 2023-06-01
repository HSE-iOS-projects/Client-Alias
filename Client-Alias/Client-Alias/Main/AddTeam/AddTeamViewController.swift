import UIKit

protocol AddTeamViewInput: AnyObject {}

protocol AddTeamViewOutput: AnyObject {
    func viewDidLoad()
    func add(team: String)
    func closeView()
}

final class AddTeamViewController: UIViewController {
    // MARK: - Properties

    private(set) lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Название команды"
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 30)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textColor = .label
        textField.layer.cornerRadius = 15
        textField.tintColor = .gray
        textField.setLeftPaddingPoints(15)
        textField.backgroundColor = .secondarySystemBackground
        textField.placeholder = "Название команды"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var addButton: UIButton = {
        let addButton = UIButton()
        addButton.layer.cornerRadius = 15
        addButton.backgroundColor = UIColor(red: 58 / 255, green: 81 / 255, blue: 151 / 255, alpha: 1)
        addButton.setTitle("Добавить", for: .normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        return addButton
    }()

    var output: AddTeamViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()

        view.backgroundColor = .systemBackground //UIColor(red: 28 / 255, green: 28 / 255, blue: 30 / 255, alpha: 1)
        setupUI()
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        output?.closeView()
        if let firstVC = presentingViewController?.children.last as? RoomInfoViewController {
            DispatchQueue.main.async {
                firstVC.output?.viewDidLoad()
            }
        }
    }
    // MARK: - Actions

    @objc func add() {
        guard let team = textField.text, !team.isEmpty else {
            return
        }
        output?.add(team: team)
    }

    // MARK: - Setup

    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(textField)
        view.addSubview(addButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 50),

            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 48),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    private func setupLocalization() {}
}

// MARK: - TroikaServiceViewInput

extension AddTeamViewController: AddTeamViewInput {}
