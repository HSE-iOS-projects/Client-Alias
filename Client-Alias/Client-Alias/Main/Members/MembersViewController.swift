import UIKit

protocol MembersViewInput: AnyObject {
    func reloadCollectionView()
}

protocol MembersViewOutput: AnyObject {
    func viewDidLoad()
    func select(user: Participants)
    func getCount() -> Int
    func getInfo(index: Int) -> Participants
    func schowAction() -> Bool
    func deleteUser(id: UUID?)
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
        return collectionView
    }()

    // MARK: - Properties

    var output: MembersViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()

        view.backgroundColor = .systemBackground
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        title = "Участники"

        setupUI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let firstVC = presentingViewController?.children.last as? RoomInfoViewController {
            DispatchQueue.main.async {
                firstVC.output?.viewDidLoad()
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

extension MembersViewController: MembersViewInput {
    func reloadCollectionView() {
        collectionView.reloadData()
    }
}

extension MembersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        output?.getCount() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let user = output?.getInfo(index: indexPath.row) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCollectionViewCell", for: indexPath) as! TitleCollectionViewCell
            cell.titleLabel.text = user.name
            cell.titleLabel.font = .systemFont(ofSize: 18)
            cell.actionButton.isHidden = !(output?.schowAction() ?? false)
            cell.actionButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
            cell.tapHandler = { [weak self] in
                self?.output?.select(user: user)
            }
            return cell
        }
        return UICollectionViewCell()
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
