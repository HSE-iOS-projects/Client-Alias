import UIKit
import ZLSwipeableViewSwift

protocol PlayRoundViewInput: AnyObject {
    func displayInfo(data: RoundInfo)
    func stopGame(isPlaying: Bool)
    func continueGame(isPlaying: Bool)
    func waitForGame(data: RoundInfo)
}

protocol PlayRoundViewOutput: AnyObject {
    func viewDidLoad()
    func getNextCardText() -> WordInfo
    func rightSwipe(index: Int)
    func leftSwipe(index: Int)
    func changeWordValue(index: Int, value: Int)
    func countUsedWords() -> Int
    func getUsedWord(index: Int) -> WordInfo
    func continueNextRound()
    func stopGame()
    func continueGame()
}

final class PlayRoundViewController: UIViewController {
    // MARK: - Properties

    private let pauseButton: UIButton = {
        let button = UIButton()
        let img = UIImage(systemName: "pause.fill")
        img?.withTintColor(.systemBlue)
        button.setImage(img, for: .normal)
        button.tag = 0
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
    
    private let wordsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Слова"
        label.textColor = .white
        label.isHidden = true
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
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.separatorColor = .clear
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(CardTableCell.self, forCellReuseIdentifier: CardTableCell.reuseIdentifier)
        table.backgroundColor = .black
        return table
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Продолжить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        button.backgroundColor = UIColor.ColorPalette.acсentColor
        button.isHidden = true
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let colors = [UIColor.purple, UIColor.orange, UIColor.green, UIColor.red]
    var colorIndex = 0
    private var timer: Timer?
    private var seconds = 0
    private var isAdmin: Bool = true
    private let swipeableView = ZLSwipeableView(frame: .zero)
    var output: PlayRoundViewOutput?

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
        output?.continueNextRound()
    }
    
    @objc
    private func pauseButtonTapped(_ sender: UITapGestureRecognizer) {
        if pauseButton.tag == 0 {
            let img2 = UIImage(systemName: "play.fill")
            img2?.withTintColor(.systemBlue)
            pauseButton.setImage(img2, for: .normal)
            output?.stopGame()
            pauseButton.tag = 1
        } else {
            let img = UIImage(systemName: "pause.fill")
            img?.withTintColor(.systemBlue)
            pauseButton.setImage(img, for: .normal)
            pauseButton.tag = 0
            output?.continueGame()
        }
       
    }
    
    @objc
    private func updateTime() {
        seconds -= 1
        timeLabel.text = timeString(time: TimeInterval(seconds))
        if seconds == 0 {
            timer?.invalidate()
            timer = nil
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.swipeableView.isHidden = true
                self.tableView.reloadData()
                self.tableView.isHidden = false
                self.continueButton.isHidden = false
                self.wordsLabel.isHidden = false
            }
        }
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.addSubview(backButton)
        view.addSubview(pauseButton)
        view.addSubview(roundLabel)
        view.addSubview(teamLabel)
        view.addSubview(timePlaceHolder)
        view.addSubview(timeLabel)
        view.addSubview(swipeableView)
        view.addSubview(wordsLabel)
        view.addSubview(tableView)
        view.addSubview(continueButton)
        
        wordsLabel.isHidden = true
        tableView.isHidden = true
        continueButton.isHidden = true
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
        tableView.delegate = self
        tableView.dataSource = self
        
        if isAdmin {
            NSLayoutConstraint.activate([
                pauseButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
                pauseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
                pauseButton.heightAnchor.constraint(equalToConstant: 40),
                pauseButton.widthAnchor.constraint(equalToConstant: 40)
            ])
        }
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.widthAnchor.constraint(equalToConstant: 40),
    
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
            timeLabel.centerYAnchor.constraint(equalTo: timePlaceHolder.centerYAnchor),
            
            wordsLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 40),
            wordsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            wordsLabel.heightAnchor.constraint(equalToConstant: 25),
            
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            continueButton.widthAnchor.constraint(equalToConstant: 300),
            
            tableView.topAnchor.constraint(equalTo: wordsLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -20),
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
            cardView.tapHandler = { value in
                self.output?.changeWordValue(index: cardView.tag, value: value)
            }
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
    
    private func setUpWaitingCards() {
        swipeableView.numberOfActiveView = 1
        
        swipeableView.nextView = {
            WaitCardView(frame: self.swipeableView.bounds)
        }
    }
    
    private func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }

    private func setupLocalization() {}
}

// MARK: - TroikaServiceViewInput

extension PlayRoundViewController: PlayRoundViewInput {
    func waitForGame(data: RoundInfo) {
        roundLabel.text = "Раунд " + data.roundNum
        teamLabel.text = data.team
        timeLabel.text = timeString(time: TimeInterval(data.timeSeconds))
        seconds = data.timeSeconds
        tableView.isHidden = true
        continueButton.isHidden = true
        wordsLabel.isHidden = true
        swipeableView.isHidden = false
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.setUpWaitingCards()
        }
    }
    
    // TODO: - остановить только если его очередь, иначе ничего не менять
    func stopGame(isPlaying: Bool) {
        if isPlaying {
            timer?.invalidate()
            timer = nil
        }
        swipeableView.isUserInteractionEnabled = false
    }
    
    func continueGame(isPlaying: Bool) {
        if isPlaying {
            timer = Timer.scheduledTimer(
                timeInterval: 1,
                target: self,
                selector: #selector(updateTime),
                userInfo: nil,
                repeats: true
            )
        }
        swipeableView.isUserInteractionEnabled = true
    }
    
    func displayInfo(data: RoundInfo) {
        roundLabel.text = "Раунд " + data.roundNum
        teamLabel.text = data.team
        timeLabel.text = timeString(time: TimeInterval(data.timeSeconds))
        seconds = data.timeSeconds
        tableView.isHidden = true
        continueButton.isHidden = true
        wordsLabel.isHidden = true
        swipeableView.isHidden = false
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateTime),
            userInfo: nil,
            repeats: true
        )
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.setupCards()
        }
        
    }
}

extension PlayRoundViewController: UITableViewDelegate, UITableViewDataSource {
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
