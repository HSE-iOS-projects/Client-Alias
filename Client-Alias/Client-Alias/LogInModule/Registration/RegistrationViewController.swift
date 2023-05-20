import UIKit

protocol RegistrationViewInput: AnyObject {
    func displayError(_ response: FormatError)
}

protocol RegistrationViewOutput: AnyObject {
    func viewDidLoad()
    func logInButtonTapped(name: String, age: String)
    func openPreviousScreen()
}

final class RegistrationViewController: UIViewController {
    // MARK: - Properties

    var output: RegistrationViewOutput?
    private let factory = LogInFactory()
    private lazy var titleText = factory.titleLabel(text: "Регистрация")
    
    private lazy var nametitle = factory.textLabel(text: "Никнейм")
    private lazy var nameText = factory.registrationTextField()
    private lazy var nameEmpty = factory.errorLabel()
    
    private lazy var ageTitle = factory.textLabel(text: "Пароль")
    private lazy var ageText = factory.registrationTextField()
    private lazy var ageEmpty = factory.errorLabel()
    private lazy var backButton = factory.backButton()
    
    private lazy var logInButton = factory.logInButton()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    // MARK: - Actions
    
    // MARK: - Actions
    @objc
    private func logInButtonTapped(_ sender: UIButton) {
        output?.logInButtonTapped(name: nameText.nonOptionalText , age: ageText.nonOptionalText)
    }
    
    @objc
    private func backButtonTapped(_ sender: UITapGestureRecognizer) {
        output?.openPreviousScreen()
    }

    // MARK: - Setup

    private func setupUI() {
        view.addSubview(titleText)
        view.addSubview(nametitle)
        view.addSubview(nameText)
        view.addSubview(ageTitle)
        view.addSubview(ageText)
        view.addSubview(logInButton)
        view.addSubview(backButton)
        view.addSubview(nameEmpty)
        view.addSubview(ageEmpty)
        nameEmpty.isHidden = true
        ageEmpty.isHidden = true
        logInButton.addTarget(self, action: #selector(logInButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            backButton.heightAnchor.constraint(equalToConstant: 25),
            backButton.widthAnchor.constraint(equalToConstant: 25),
            
            
            titleText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            titleText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleText.heightAnchor.constraint(equalToConstant: 50),
            
            nametitle.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 60),
            nametitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nametitle.heightAnchor.constraint(equalToConstant: 18),
            
            nameEmpty.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 60),
            nameEmpty.leadingAnchor.constraint(equalTo: nametitle.trailingAnchor, constant: 30),
            nameEmpty.heightAnchor.constraint(equalToConstant: 18),
            
            nameText.topAnchor.constraint(equalTo: nametitle.bottomAnchor, constant: 9),
            nameText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            nameText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            nameText.heightAnchor.constraint(equalToConstant: 50),
            
            ageTitle.topAnchor.constraint(equalTo: nameText.bottomAnchor, constant: 40),
            ageTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ageTitle.heightAnchor.constraint(equalToConstant: 18),
            
            ageEmpty.topAnchor.constraint(equalTo: nameText.bottomAnchor, constant: 40),
            ageEmpty.leadingAnchor.constraint(equalTo: ageTitle.trailingAnchor, constant: 30),
            ageEmpty.heightAnchor.constraint(equalToConstant: 18),
            
            ageText.topAnchor.constraint(equalTo: ageTitle.bottomAnchor, constant: 9),
            ageText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            ageText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            ageText.heightAnchor.constraint(equalToConstant: 50),
            
            logInButton.topAnchor.constraint(equalTo: ageText.bottomAnchor, constant: 180),
            logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logInButton.heightAnchor.constraint(equalToConstant: 50),
            logInButton.widthAnchor.constraint(equalToConstant: 300)
        ])
    }

    private func setupLocalization() {}
}

// MARK: - TroikaServiceViewInput

extension RegistrationViewController: RegistrationViewInput {
    func displayError(_ response: FormatError) {
        nameEmpty.text = response.nameError
        ageEmpty.text = response.ageError
        nameEmpty.isHidden = false
        ageEmpty.isHidden = false
    }
}
