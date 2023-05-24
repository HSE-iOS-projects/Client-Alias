import UIKit

protocol MembersViewInput: AnyObject {
}

protocol MembersViewOutput: AnyObject {
    func viewDidLoad()
    func select(user: String)
}

final class MembersViewController: UIViewController {
    // MARK: - Outlets

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset.top = 16
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: "TitleCollectionViewCell")
        collectionView.backgroundColor = .black
        return collectionView
    }()

    // MARK: - Properties

    let users = ["User 1", "User 2", "User 3", "User 3", "User 3", "User 3", "User 3", "User 3"]

    var output: MembersViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()

        title = "Участники"
        
        setupUI()
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

extension MembersViewController: MembersViewInput {
}

extension MembersViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let user = users[indexPath.row]
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

extension MembersViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 16 * 2, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
    }
}
