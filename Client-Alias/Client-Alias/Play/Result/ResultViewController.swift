import UIKit

protocol ResultViewInput: AnyObject {
    func showInfo(winner: String)
}

protocol ResultViewOutput: AnyObject {
    func viewDidLoad()
    func countTeams() -> Int
    func getTeamInfo(index: Int) -> TeamResultInfo
}

final class ResultViewController: UIViewController {
    // MARK: - Outlets

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
    
    private let winnerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
//        label.backgroundColor = UIColor.ColorPalette.acсentColor
//        label.layer.cornerRadius = 15
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 37, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let winnerPlaceHolder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ColorPalette.acсentColor
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private let allTeamsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Все команды"
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
        table.register(TeamCell.self, forCellReuseIdentifier: TeamCell.reuseIdentifier)
        table.backgroundColor = .black
        return table
    }()
    
    private let endButton: UIButton = {
        let button = UIButton()
        button.setTitle("Завершить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        button.backgroundColor = UIColor.ColorPalette.acсentColor
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var output: ResultViewOutput?

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
    private func endButtonTapped(_ sender: UITapGestureRecognizer) {
    }


    // MARK: - Setup

    private func setupUI() {
        view.addSubview(winnerPlaceHolder)
        view.addSubview(backButton)
        view.addSubview(winnerLabel)
        view.addSubview(allTeamsLabel)
        view.addSubview(tableView)
        view.addSubview(endButton)
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        endButton.addTarget(self, action: #selector(endButtonTapped), for: .touchUpInside)

        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            backButton.heightAnchor.constraint(equalToConstant: 25),
            backButton.widthAnchor.constraint(equalToConstant: 25),
            
            winnerPlaceHolder.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 30),
            winnerPlaceHolder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            winnerPlaceHolder.heightAnchor.constraint(equalToConstant: 200),
            winnerPlaceHolder.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            
            winnerLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 40),
            winnerLabel.centerXAnchor.constraint(equalTo: winnerPlaceHolder.centerXAnchor),
            winnerLabel.heightAnchor.constraint(equalToConstant: 180),
            winnerLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 60),
            
            allTeamsLabel.topAnchor.constraint(equalTo: winnerLabel.bottomAnchor, constant: 40),
            allTeamsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            allTeamsLabel.heightAnchor.constraint(equalToConstant: 25),
            
            endButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            endButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            endButton.heightAnchor.constraint(equalToConstant: 50),
            endButton.widthAnchor.constraint(equalToConstant: 300),
            
            tableView.topAnchor.constraint(equalTo: allTeamsLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: endButton.topAnchor, constant: -20),
        ])
        
    }

    private func setupLocalization() {}
}

// MARK: - TroikaServiceViewInput

extension ResultViewController: ResultViewInput {
    func showInfo(winner: String) {
        winnerLabel.text = "Поздравляем, \n"  + winner
    }
}

extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        output?.countTeams() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TeamCell.reuseIdentifier, for: indexPath) as? TeamCell
        let data = output?.getTeamInfo(index: indexPath.row)
        
        guard let cell = cell else {
            return UITableViewCell()
        }
        
        cell.config(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 60
       }
    
}
