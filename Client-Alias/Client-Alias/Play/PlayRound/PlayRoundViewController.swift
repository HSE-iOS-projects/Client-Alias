import UIKit
import ZLSwipeableViewSwift

protocol PlayRoundViewInput: AnyObject {
    func displayInfo(data: RoundInfo)
}

protocol PlayRoundViewOutput: AnyObject {
    func viewDidLoad()
    func getNextCardText() -> WordInfo
    func rightSwipe(index: Int)
    func leftSwipe(index: Int)
    func changeWordValue(index: Int, value: Int)
}

final class PlayRoundViewController: UIViewController {
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
    
    private let roundLabel: UILabel = {
        let titleText = UILabel()
        titleText.numberOfLines = 0
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
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timePlaceHolder: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let colors = [UIColor.purple, UIColor.orange, UIColor.green, UIColor.red]
    var colorIndex = 0
    private var timer = Timer()
    var seconds = 0
    private let swipeableView = ZLSwipeableView(frame: .zero)
    var output: PlayRoundViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
        setupUI()
        setupCards()
    }

    // MARK: - Actions

    @objc
    private func backButtonTapped(_ sender: UITapGestureRecognizer) {}
    
    @objc
    private func updateTime() {
        seconds -= 1
        timeLabel.text = timeString(time: TimeInterval(seconds))
        if seconds == 0 {
            timer.invalidate()
        }
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.addSubview(backButton)
        view.addSubview(roundLabel)
        view.addSubview(teamLabel)
        view.addSubview(timePlaceHolder)
        view.addSubview(timeLabel)
        view.addSubview(swipeableView)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateTime),
            userInfo: nil,
            repeats: true
        )

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            backButton.heightAnchor.constraint(equalToConstant: 25),
            backButton.widthAnchor.constraint(equalToConstant: 25),
            
            roundLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 40),
            roundLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            roundLabel.heightAnchor.constraint(equalToConstant: 40),
            
            teamLabel.topAnchor.constraint(equalTo: roundLabel.bottomAnchor, constant: 50),
            teamLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            teamLabel.heightAnchor.constraint(equalToConstant: 25),
            
            timePlaceHolder.topAnchor.constraint(equalTo: teamLabel.bottomAnchor, constant: 30),
            timePlaceHolder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timePlaceHolder.heightAnchor.constraint(equalToConstant: 45 + 20),
            timePlaceHolder.widthAnchor.constraint(equalToConstant: 100),
            
            timeLabel.topAnchor.constraint(equalTo: teamLabel.bottomAnchor, constant: 40),
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: timePlaceHolder.centerYAnchor)
        ])
        
        swipeableView.frame = CGRect(
            x: (UIScreen.main.bounds.width - 300) / 2,
            y: 400,
            width: 300,
            height: 200
        )
    }
    
    private func setupCards() {
        swipeableView.numberOfActiveView = 4

        swipeableView.nextView = { [weak self] in
            guard let self = self else {
                return UIView()
            }
            
            let cardView = CardView(frame: self.swipeableView.bounds)
            let wordInfo = self.output?.getNextCardText()
            cardView.config(
                text: wordInfo?.word ?? "",
                color: self.colors[self.colorIndex]
            )
            cardView.tag = wordInfo?.index ?? -1
            self.colorIndex += 1
            if self.colorIndex == self.colors.count {
                self.colorIndex = 0
            }
            return cardView
        }
        
        swipeableView.didSwipe = { view, direction, _ in
            switch direction {
            case .Right:
                self.output?.rightSwipe(index: view.tag)
            case .Left:
                self.output?.leftSwipe(index: view.tag)
            default:
                break
            }
        }
    }
    
    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }

    private func setupLocalization() {}
}

// MARK: - TroikaServiceViewInput

extension PlayRoundViewController: PlayRoundViewInput {
    func displayInfo(data: RoundInfo) {
        roundLabel.text = "Раунд " + data.roundNum
        teamLabel.text = data.team
        timeLabel.text = timeString(time: TimeInterval(data.timeSeconds))
        seconds = data.timeSeconds
    }
}
