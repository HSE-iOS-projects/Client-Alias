import UIKit

protocol EndGameViewInput: AnyObject {}

protocol EndGameViewOutput: AnyObject {
    func viewDidLoad()
    func changeWordValue(index: Int, value: Int)
    func countUsedWords() -> Int
    func getUsedWord(index: Int) -> WordInfo
}

final class EndGameViewController: UIViewController {
    // MARK: - Properties

    private let endLabel: UILabel = {
        let titleText = UILabel()
        titleText.numberOfLines = 0
        titleText.text = "Ожидайте результатов"
        titleText.textColor = .label
        titleText.lineBreakMode = .byWordWrapping
        titleText.textAlignment = .center
        titleText.font = UIFont.systemFont(ofSize: 37, weight: .bold)
        titleText.translatesAutoresizingMaskIntoConstraints = false
        return titleText
    }()

    private var loadingView = SquareLoadingView()

    var output: EndGameViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    // MARK: - Setup

    private func setupUI() {
        setupLoading()
        loadingView.startAnimation()
        view.addSubview(endLabel)

        NSLayoutConstraint.activate([
            endLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90),
            endLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            endLabel.heightAnchor.constraint(equalToConstant: 90),
            endLabel.widthAnchor.constraint(equalToConstant: 300),
        ])
    }

    private func setupLoading() {
        view.addSubview(loadingView)
        loadingView.center = view.center
    }

    private func setupLocalization() {}
}

// MARK: - TroikaServiceViewInput

extension EndGameViewController: EndGameViewInput {}
