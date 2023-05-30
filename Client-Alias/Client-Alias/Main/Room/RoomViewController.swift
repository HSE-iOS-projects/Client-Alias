import UIKit

protocol RoomViewInput: AnyObject {}

protocol RoomViewOutput: AnyObject {
    func viewDidLoad()
    func save(name: String, isPrivate: Bool, url: String)
    func cancel()
    func generateCode() -> String
}

final class RoomViewController: UIViewController {
    // MARK: - Outlets

    private lazy var yourNameLabel: UILabel = MainFactory.makeLabel(text: "Your name")
    private lazy var textField: UITextField = MainFactory.makeTextField(text: "Type here", mainText: "My Room")
    private lazy var urlLabel: UILabel = MainFactory.makeLabel(text: "Связь")
    private lazy var urlTextField: UITextField = MainFactory.makeTextField(text: "Ссылка", mainText: "1")
    private lazy var privateRoomLabel: UILabel = MainFactory.makeLabel(text: "Закрытая")
    
    private lazy var privateSwitch: UISwitch = {
        let privateSwitch = UISwitch()
        privateSwitch.translatesAutoresizingMaskIntoConstraints = false
        return privateSwitch
    }()

    private lazy var saveButton: UIButton = {
        let addButton = UIButton()
        addButton.layer.cornerRadius = 15
        addButton.backgroundColor = UIColor(red: 58 / 255, green: 81 / 255, blue: 151 / 255, alpha: 1)
        addButton.setTitle("Сохранить", for: .normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        return addButton
    }()

    private lazy var cancelButton: UIButton = {
        let addButton = UIButton()
        addButton.layer.cornerRadius = 15
        addButton.backgroundColor = UIColor(red: 28 / 255, green: 28 / 255, blue: 30 / 255, alpha: 1)
        addButton.setTitle("Отменить", for: .normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return addButton
    }()

    // MARK: - Properties

    var output: RoomViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
        view.backgroundColor = .black
        title = "Комната"
        
        setupUI()
        

        // TODO: Fix
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap))
        view.addGestureRecognizer(tap)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    // MARK: - Actions

    @objc func tap() {
        view.endEditing(true)
    }

    @objc func save() {
        guard let name = textField.text, !name.isEmpty else {
            return
        }
        guard let url = urlTextField.text, !url.isEmpty else {
            return
        }
        output?.save(name: name, isPrivate: privateSwitch.isOn, url: url)
    }

    @objc func cancel() {
        output?.cancel()
    }

    // MARK: - Setup

    private func setupUI() {
        view.addSubview(yourNameLabel)
        view.addSubview(textField)
        view.addSubview(urlLabel)
        view.addSubview(urlTextField)
        view.addSubview(privateRoomLabel)
        view.addSubview(privateSwitch)
        view.addSubview(saveButton)
        view.addSubview(cancelButton)

        NSLayoutConstraint.activate([
            yourNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            yourNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            yourNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            textField.topAnchor.constraint(equalTo: yourNameLabel.bottomAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 32),

            urlLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            urlLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            urlLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            urlTextField.topAnchor.constraint(equalTo: urlLabel.bottomAnchor, constant: 8),
            urlTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            urlTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            urlTextField.heightAnchor.constraint(equalToConstant: 32),

            privateRoomLabel.topAnchor.constraint(equalTo: urlTextField.bottomAnchor, constant: 20),
            privateRoomLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            privateRoomLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            privateSwitch.topAnchor.constraint(equalTo: privateRoomLabel.bottomAnchor, constant: 8),
            privateSwitch.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            saveButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -8),
            saveButton.heightAnchor.constraint(equalToConstant: 44),

            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            cancelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }

    private func setupLocalization() {}
}

// MARK: - TroikaServiceViewInput

extension RoomViewController: RoomViewInput {}
