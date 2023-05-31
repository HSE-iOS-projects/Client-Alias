import UIKit

protocol TeamsViewInput: AnyObject {}

protocol TeamsViewOutput: AnyObject {
    func viewDidLoad()
    func getCount() -> Int
    func getTeam(index: Int) -> String
    func selectTeam(index: Int)
    func hasChanges() -> Bool
    func getParticipant() -> UUID
}

final class TeamsViewController: UIViewController {
    // MARK: - Outlets

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: "TitleCollectionViewCell")
        collectionView.register(TextFieldCollectionViewCell.self, forCellWithReuseIdentifier: "TextFieldCollectionViewCell")
        collectionView.backgroundColor = UIColor(red: 28 / 255, green: 28 / 255, blue: 30 / 255, alpha: 1)
        return collectionView
    }()

    // MARK: - Properties

    var output: TeamsViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
        setupUI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let firstVC = presentingViewController?.children.last as? RoomInfoViewController {
            DispatchQueue.main.async {
                firstVC.output?.viewDidLoad()
            }
        }
        
        if let firstVC = presentingViewController?.children.last as? MembersViewController {
            DispatchQueue.main.async {
                firstVC.output?.deleteUser(id: self.output?.getParticipant())
            }
        }
        
       
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

extension TeamsViewController: TeamsViewInput {
}

extension TeamsViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        output?.getCount() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCollectionViewCell", for: indexPath) as! TitleCollectionViewCell
            cell.titleLabel.font = .systemFont(ofSize: 24)
            cell.titleLabel.text = "Команды"
            return cell
        }
        let team = output?.getTeam(index: indexPath.row - 1)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCollectionViewCell", for: indexPath) as! TitleCollectionViewCell
        cell.titleLabel.text = team
        cell.titleLabel.font = .systemFont(ofSize: 18)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            output?.selectTeam(index: indexPath.row - 1)
        }
    }
}

extension TeamsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 16 * 2, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
    }
}
