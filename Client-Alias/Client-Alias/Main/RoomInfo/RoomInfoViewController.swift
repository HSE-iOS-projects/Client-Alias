import UIKit

protocol RoomInfoViewInput: AnyObject {

    func update(room: Room)
}

protocol RoomInfoViewOutput: AnyObject {
    func viewDidLoad()
    func select(user: String)
    func select(team: String)
    func addTeam()
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

    // MARK: - Properties

    let isMyTeam = false
    let teams = ["Team 1", "Team 2", "Team 3", "Team 3", "Team 3", "Team 3", "Team 3", "Team 3",]
    let users = ["User 1", "User 2", "User 3", "User 3", "User 3", "User 3", "User 3", "User 3"]

    var output: RoomInfoViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
        
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    // MARK: - Actions

    // MARK: - Setup

    private func setupUI() {
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
            return isMyTeam ? 1 : 0
        case 1:
            return 2
        case 2:
            return teams.count + 1
        case 3:
            return users.count + 1
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
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCollectionViewCell", for: indexPath) as! TitleCollectionViewCell
                cell.titleLabel.font = .systemFont(ofSize: 24)
                cell.titleLabel.text = "Связь"
                return cell
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextFieldCollectionViewCell", for: indexPath) as! TextFieldCollectionViewCell
            cell.textView.isEditable = isAdmin
            return cell
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
            let team = teams[indexPath.row - 1]
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
        let user = users[indexPath.row - 1]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCollectionViewCell", for: indexPath) as! TitleCollectionViewCell
        cell.titleLabel.text = user
        cell.titleLabel.font = .systemFont(ofSize: 18)
        cell.actionButton.isHidden = false
        cell.actionButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        cell.tapHandler = { [weak self] in
            self?.output?.select(user: user)
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
            let team = teams[indexPath.row - 1]
            output?.select(team: team)
        }
    }
}
