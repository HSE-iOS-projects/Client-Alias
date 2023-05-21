import UIKit

protocol ProfileViewInput: AnyObject {

    func update(user: User)
}

protocol ProfileViewOutput: AnyObject {
    func viewDidLoad()
    func logout()
}

final class ProfileViewController: UIViewController {
    // MARK: - Outlets

    // MARK: - Properties

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.text = "Ник"
        titleLabel.font = .boldSystemFont(ofSize: 37)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        // 14 18
        // 28 28 30
//        stackView.backgroundColor = .gray
        stackView.backgroundColor = UIColor(red: 28 / 255, green: 28 / 255, blue: 30 / 255, alpha: 1)
        stackView.layer.cornerRadius = 15
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 34
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 18, leading: 14, bottom: 18, trailing: 14)
        return stackView
    }()

    private lazy var playedGamesLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.text = "Сыгранные игры: 10"
        titleLabel.font = .systemFont(ofSize: 20)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()

    private lazy var winGamesLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.text = "Выиграл игры: 12"
        titleLabel.font = .systemFont(ofSize: 20)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()

    private lazy var logoutButton: UIButton = {
        let logoutButton = UIButton()
//        logoutButton.backgroundColor = .yellow
        logoutButton.setTitle("Выйти", for: .normal)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        return logoutButton
    }()

    private lazy var deleteProfileButton: UIButton = {
        let deleteProfileButton = UIButton()
//        logoutButton.backgroundColor = .yellow
        deleteProfileButton.setTitle("Удалить профиль", for: .normal)
        deleteProfileButton.setTitleColor(.red, for: .normal)
        deleteProfileButton.translatesAutoresizingMaskIntoConstraints = false
        deleteProfileButton.addTarget(self, action: #selector(deleteProfile), for: .touchUpInside)
        return deleteProfileButton
    }()

    var output: ProfileViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
        view.backgroundColor = .black
        tabBarItem.title = "Profile"
        tabBarItem.image = UIImage(systemName: "person.fill")

        view.addSubview(titleLabel)
        view.addSubview(stackView)

        stackView.addArrangedSubview(playedGamesLabel)
        stackView.addArrangedSubview(winGamesLabel)
        stackView.addArrangedSubview(logoutButton)

        view.addSubview(deleteProfileButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 34),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            deleteProfileButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            deleteProfileButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
    }

    // MARK: - Actions

    @objc func logout() {
        output?.logout()
    }

    @objc func deleteProfile() {
        // TODO: перенести в презентер
        print("deleteProfile")
    }

    // MARK: - Setup

    private func setupUI() {}

    private func setupLocalization() {}
}

// MARK: - TroikaServiceViewInput

extension ProfileViewController: ProfileViewInput {

    func update(user: User) {
        titleLabel.text = user.name
        playedGamesLabel.text = "Сыгранные игры: \(user.playedGames)"
        winGamesLabel.text = "Выиграл игры: \(user.winGames)"
    }
}
