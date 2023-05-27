import UIKit

protocol EndGameViewInput: AnyObject {
    func displayInfo(team: String)
}

protocol EndGameViewOutput: AnyObject {
    func viewDidLoad()
    func changeWordValue(index: Int, value: Int)
    func countUsedWords() -> Int
    func getUsedWord(index: Int) -> WordInfo
    func showResults()
}

final class EndGameViewController: UIViewController {

    // MARK: - Properties
    private let backButton: UIButton = {
        let button = UIButton()
        let img = UIImage(systemName: "arrow.left")
        img?.withTintColor(.systemBlue)
        button.setImage(img, for: .normal)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let endLabel: UILabel = {
        let titleText = UILabel()
        titleText.numberOfLines = 0
        titleText.text = "Конец"
        titleText.textColor = .white
        titleText.font = UIFont.systemFont(ofSize: 37, weight: .bold)
        titleText.translatesAutoresizingMaskIntoConstraints = false
        return titleText
    }()
    
    private let teamLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 23, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let allWordsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Все слова"
        label.textColor = .white
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 23, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.separatorColor = .clear
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(CardTableCell.self, forCellReuseIdentifier: CardTableCell.reuseIdentifier)
        table.backgroundColor = .black
        return table
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Подвести итоги", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        button.backgroundColor = UIColor.ColorPalette.acсentColor
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var output: EndGameViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
        setupUI()
    }

    // MARK: - Actions
    
    @objc
    private func backButtonTapped(_ sender: UITapGestureRecognizer) {}
    
    @objc
    private func continueButtonTapped(_ sender: UITapGestureRecognizer) {
        output?.showResults() 
    }

    // MARK: - Setup

    private func setupUI() {
        view.addSubview(backButton)
        view.addSubview(endLabel)
        view.addSubview(teamLabel)
        view.addSubview(allWordsLabel)
        view.addSubview(tableView)
        view.addSubview(continueButton)
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)

        tableView.delegate = self
        tableView.dataSource = self
       
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            backButton.heightAnchor.constraint(equalToConstant: 25),
            backButton.widthAnchor.constraint(equalToConstant: 25),
            
            endLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 40),
            endLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            endLabel.heightAnchor.constraint(equalToConstant: 40),
            
            teamLabel.topAnchor.constraint(equalTo: endLabel.bottomAnchor, constant: 50),
            teamLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            teamLabel.heightAnchor.constraint(equalToConstant: 25),
 
            
            allWordsLabel.topAnchor.constraint(equalTo: teamLabel.bottomAnchor, constant: 40),
            allWordsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            allWordsLabel.heightAnchor.constraint(equalToConstant: 25),
            
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            continueButton.widthAnchor.constraint(equalToConstant: 300),
            
            tableView.topAnchor.constraint(equalTo: allWordsLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -20),
        ])
        
    }

    private func setupLocalization() {}
}

// MARK: - TroikaServiceViewInput

extension EndGameViewController: EndGameViewInput {
    func displayInfo(team: String) {
        teamLabel.text = team
        tableView.reloadData()
    }
}

extension EndGameViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        output?.countUsedWords() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CardTableCell.reuseIdentifier, for: indexPath) as? CardTableCell
        let data = output?.getUsedWord(index: indexPath.row)
        
        guard let cell = cell else {
            return UITableViewCell()
        }
        
        cell.config(data: data)
        cell.tapHandler = { [weak self] value, index in
            self?.output?.changeWordValue(index: index, value: value)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 60
       }
    
}
