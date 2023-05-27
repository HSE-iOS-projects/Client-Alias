import UIKit

protocol RoomInfoViewInput: AnyObject {

    var viewModel: RoomInfoViewModel? { get set }
}

protocol RoomInfoViewOutput: AnyObject {
    func viewDidLoad()
    func select(user: String)
    func select(team: String)
    func addTeam()
    func start()
}

final class RoomInfoViewController: UIViewController {
    // MARK: - Outlets

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: "TitleCollectionViewCell")
        collectionView.register(TextFieldCollectionViewCell.self, forCellWithReuseIdentifier: "TextFieldCollectionViewCell")
        collectionView.backgroundColor = .black
        return collectionView
    }()

    private lazy var startButton: UIButton = {
        let startButton = UIButton()
        startButton.layer.cornerRadius = 15
        startButton.backgroundColor = UIColor(red: 58 / 255, green: 81 / 255, blue: 151 / 255, alpha: 1)
        startButton.setTitle("Начать игру", for: .normal)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(start), for: .touchUpInside)
        startButton.isHidden = !isAdmin
        return startButton
    }()

    // MARK: - Properties

    var viewModel: RoomInfoViewModel? {
        didSet {
            guard isViewLoaded, viewModel != oldValue else {
                return
            }
            collectionView.reloadData()
        }
    }

    var output: RoomInfoViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()

        title = "Подготовка"
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    // MARK: - Actions

    @objc func start() {
        output?.start()
    }

    // MARK: - Setup

    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(startButton)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            startButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            startButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            startButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }

    private func setupLocalization() {}
}

// MARK: - TroikaServiceViewInput

extension RoomInfoViewController: RoomInfoViewInput {

    func update(room: Room) {
        title = room.name
    }
}

extension RoomInfoViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        4
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel?.isMyTeam == true ? 1 : 0
        case 1:
            return 4
        case 2:
            if let viewModel {
                return viewModel.teams.count + 1
            }
            return 0
        case 3:
            if let viewModel {
                return viewModel.users.count + 1
            }
            return 0
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCollectionViewCell", for: indexPath) as! TitleCollectionViewCell
            cell.titleLabel.font = .systemFont(ofSize: 24)
            cell.titleLabel.text = "Твоя команда"
            return cell
        }
        else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCollectionViewCell", for: indexPath) as! TitleCollectionViewCell
                cell.titleLabel.font = .systemFont(ofSize: 24)
                cell.titleLabel.text = "Связь"
                return cell
            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextFieldCollectionViewCell", for: indexPath) as! TextFieldCollectionViewCell
                cell.textView.isEditable = isAdmin
                cell.textView.text = viewModel?.room.url
                return cell
            case 2:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCollectionViewCell", for: indexPath) as! TitleCollectionViewCell
                cell.titleLabel.font = .systemFont(ofSize: 24)
                cell.titleLabel.text = "Ключ"
                return cell
            case 3:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextFieldCollectionViewCell", for: indexPath) as! TextFieldCollectionViewCell
                cell.textView.isEditable = false
                cell.textView.text = viewModel?.room.code
                return cell
            default:
                fatalError()
            }
        }
        else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCollectionViewCell", for: indexPath) as! TitleCollectionViewCell
                cell.titleLabel.font = .systemFont(ofSize: 24)
                cell.titleLabel.text = "Команды"
                cell.actionButton.isHidden = isAdmin == false
                cell.actionButton.setImage(UIImage(systemName: "plus"), for: .normal)
                cell.tapHandler = { [weak self] in
                    self?.output?.addTeam()
                }
                return cell
            }
            let team = viewModel?.teams[indexPath.row - 1]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCollectionViewCell", for: indexPath) as! TitleCollectionViewCell
            cell.titleLabel.text = team
            cell.titleLabel.font = .systemFont(ofSize: 18)
            return cell
        }
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCollectionViewCell", for: indexPath) as! TitleCollectionViewCell
            cell.titleLabel.font = .systemFont(ofSize: 24)
            cell.titleLabel.text = "Участники без команды"
            return cell
        }
        let user = viewModel?.users[indexPath.row - 1]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCollectionViewCell", for: indexPath) as! TitleCollectionViewCell
        cell.titleLabel.text = user
        cell.titleLabel.font = .systemFont(ofSize: 18)
        cell.actionButton.isHidden = false
        cell.actionButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        cell.tapHandler = { [weak self] in
            if let user {
                self?.output?.select(user: user)
            }
        }
        return cell
    }
}

extension RoomInfoViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 16 * 2, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if let team = viewModel?.teams[indexPath.row - 1] {
                output?.select(team: team)
            }
        }
    }
}
