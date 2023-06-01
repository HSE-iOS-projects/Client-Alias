import UIKit

protocol ResultViewInput: AnyObject {
    func showInfo(winner: String)
}

protocol ResultViewOutput: AnyObject {
    func viewDidLoad()
    func countTeams() -> Int
    func getTeamInfo(index: Int) -> TeamResultInfo
    func openMain()
}

final class ResultViewController: UIViewController {
    // MARK: - Outlets

    // MARK: - Properties
    
    private let winnerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
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
        view.backgroundColor = .systemBackground
        setupUI()
    }

    // MARK: - Actions
    @objc
    private func endButtonTapped(_ sender: UITapGestureRecognizer) {
        output?.openMain()
    }


    // MARK: - Setup

    private func setupUI() {
        view.addSubview(winnerPlaceHolder)
        view.addSubview(winnerLabel)
        view.addSubview(endButton)

        endButton.addTarget(self, action: #selector(endButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            winnerPlaceHolder.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            winnerPlaceHolder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            winnerPlaceHolder.heightAnchor.constraint(equalToConstant: 220),
            winnerPlaceHolder.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            
            winnerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            winnerLabel.centerXAnchor.constraint(equalTo: winnerPlaceHolder.centerXAnchor),
            winnerLabel.heightAnchor.constraint(equalToConstant: 200),
            winnerLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 60),
            
            endButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            endButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            endButton.heightAnchor.constraint(equalToConstant: 50),
            endButton.widthAnchor.constraint(equalToConstant: 300),
        ])
        
    }

    private func setupLocalization() {}
}

// MARK: - TroikaServiceViewInput

extension ResultViewController: ResultViewInput {
    func showInfo(winner: String) {
        winnerLabel.text = winner
    }
}
