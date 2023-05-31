import UIKit

protocol GameSettingsViewInput: AnyObject {
    func showError(error: String)
}

protocol GameSettingsViewOutput: AnyObject {
    func viewDidLoad()
    func continueGame(roundNum: String)
}

final class GameSettingsViewController: UIViewController {
    // MARK: - Outlets

    private lazy var roundsLabel: UILabel = MainFactory.makeLabel(text: "Количество раундов")

    private lazy var roundTextField: UITextField = MainFactory.makeTextField(text: "Количество раундов")
    private var roundEmpty: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .systemRed
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        output?.continueGame(roundNum: roundTextField.text ?? "")
    }

    // MARK: - Setup

    private func setupUI() {
//        view.addSubview(timeLabel)
//        view.addSubview(timeTextField)
        view.addSubview(roundsLabel)
        view.addSubview(roundEmpty)
        view.addSubview(roundTextField)
        view.addSubview(continueButton)

        NSLayoutConstraint.activate([
//            timeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
//            timeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
//            timeLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
//
//            timeTextField.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8),
//            timeTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
//            timeTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
//            timeTextField.heightAnchor.constraint(equalToConstant: 32),

            roundsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            roundsLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            roundsLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            roundEmpty.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            roundEmpty.leadingAnchor.constraint(equalTo: roundsLabel.trailingAnchor, constant: 30),
            roundEmpty.heightAnchor.constraint(equalToConstant: 18),
            
            roundTextField.topAnchor.constraint(equalTo: roundsLabel.bottomAnchor, constant: 9),
            roundTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            roundTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            roundTextField.heightAnchor.constraint(equalToConstant: 50),

            continueButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            continueButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            continueButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }

    private func setupLocalization() {}
}

// MARK: - TroikaServiceViewInput

extension GameSettingsViewController: GameSettingsViewInput {
    func showError(error: String) {
        roundEmpty.isHidden = false
        roundEmpty.text = error
    }
}
