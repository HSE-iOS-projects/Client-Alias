import UIKit

protocol GameSettingsViewInput: AnyObject {}

protocol GameSettingsViewOutput: AnyObject {
    func viewDidLoad()
    func continueGame()
}

final class GameSettingsViewController: UIViewController {
    // MARK: - Outlets

    private lazy var timeLabel: UILabel = MainFactory.makeLabel(text: "Время раунда")

    private lazy var timeTextField: UITextField = MainFactory.makeTextField(text: "Время раунда")

    private lazy var roundsLabel: UILabel = MainFactory.makeLabel(text: "Количество раундов")

    private lazy var roundTextField: UITextField = MainFactory.makeTextField(text: "Количество раундов")

    private lazy var continueButton: UIButton = {
        let addButton = UIButton()
        addButton.layer.cornerRadius = 15
        addButton.backgroundColor = UIColor(red: 58 / 255, green: 81 / 255, blue: 151 / 255, alpha: 1)
        addButton.setTitle("Продолжить", for: .normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(continueGame), for: .touchUpInside)
        return addButton
    }()

    // MARK: - Properties

    var output: GameSettingsViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
        view.backgroundColor = .black
        title = "Настройка игры"
        
        setupUI()
    }

    // MARK: - Actions

    @objc func continueGame() {
        output?.continueGame()
    }

    // MARK: - Setup

    private func setupUI() {
        view.addSubview(timeLabel)
        view.addSubview(timeTextField)
        view.addSubview(roundsLabel)
        view.addSubview(roundTextField)
        view.addSubview(continueButton)

        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            timeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            timeLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            timeTextField.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8),
            timeTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            timeTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            timeTextField.heightAnchor.constraint(equalToConstant: 32),

            roundsLabel.topAnchor.constraint(equalTo: timeTextField.bottomAnchor, constant: 20),
            roundsLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            roundsLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            roundTextField.topAnchor.constraint(equalTo: roundsLabel.bottomAnchor, constant: 8),
            roundTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            roundTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            roundTextField.heightAnchor.constraint(equalToConstant: 32),

            continueButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            continueButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            continueButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }

    private func setupLocalization() {}
}

// MARK: - TroikaServiceViewInput

extension GameSettingsViewController: GameSettingsViewInput {}
