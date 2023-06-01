import UIKit

protocol RoomsViewInput: AnyObject {

    var viewModel: RoomsViewModel? { get set }
}

protocol RoomsViewOutput: AnyObject {
    func viewDidLoad()
    func add()
    func addKey()
    func getInfo()
    func select(room: Room, isActive: Bool)
}

final class RoomsViewController: UIViewController {
    // MARK: - Outlets

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RoomCollectionViewCell.self, forCellWithReuseIdentifier: "RoomCollectionViewCell")
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: "TitleCollectionViewCell")
//        collectionView.backgroundColor = .black
        return collectionView
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
//        textField.borderStyle = .roundedRect
         textField.layer.cornerRadius = 15
        textField.setLeftPaddingPoints(15)
        textField.tintColor = .gray
        textField.backgroundColor = .secondarySystemBackground //UIColor(red: 28 / 255, green: 28 / 255, blue: 30 / 255, alpha: 1)
        textField.placeholder = "Название комнаты"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var addButton: UIButton = {
        let addButton = UIButton()
        addButton.tintColor = .label
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        return addButton
    }()

    private lazy var keyButton: UIButton = {
        let keyButton = UIButton()
        keyButton.tintColor = .label
        keyButton.setImage(UIImage(systemName: "key.fill"), for: .normal)
        keyButton.translatesAutoresizingMaskIntoConstraints = false
        keyButton.addTarget(self, action: #selector(addKey), for: .touchUpInside)
        return keyButton
    }()

    
    private var refresher = UIRefreshControl()
    // MARK: - Properties

    var output: RoomsViewOutput?
    var viewModel: RoomsViewModel? {
        didSet {
            collectionView.refreshControl?.endRefreshing()
            guard isViewLoaded, viewModel != oldValue else {
                return
            }
            collectionView.reloadData()
            
        }
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Комнаты"
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output?.viewDidLoad()
    }

    // MARK: - Actions

    @objc func add() {
        output?.add()
    }

    @objc func addKey() {
        output?.addKey()
    }

    @objc func loadData() {
        collectionView.refreshControl?.beginRefreshing()
        output?.getInfo()
     }
    // MARK: - Setup

    private func setupUI() {
        collectionView.alwaysBounceVertical = true
        refresher.tintColor = .systemBlue
        refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        collectionView.refreshControl = refresher 
        view.addSubview(textField)
        view.addSubview(addButton)
        view.addSubview(keyButton)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 32),

            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            addButton.widthAnchor.constraint(equalToConstant: 32),
            addButton.heightAnchor.constraint(equalToConstant: 32),
            addButton.trailingAnchor.constraint(equalTo: keyButton.leadingAnchor, constant: -16),

            keyButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            keyButton.widthAnchor.constraint(equalToConstant: 32),
            keyButton.heightAnchor.constraint(equalToConstant: 32),
            keyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -16),

            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 5),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupLocalization() {}
}

// MARK: - TroikaServiceViewInput

extension RoomsViewController: RoomsViewInput {
}

extension RoomsViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel?.activeRoom == nil ? 0 : 2
        }
        guard let viewModel = viewModel else {
            return 0
        }
        return viewModel.openRooms.count == 0 ? 0 : viewModel.openRooms.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCollectionViewCell", for: indexPath) as! TitleCollectionViewCell
                cell.titleLabel.text = "Активная комната"
                return cell
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomCollectionViewCell", for: indexPath) as! RoomCollectionViewCell
            let activeRoom = viewModel?.activeRoom
            cell.titleLabel.text = activeRoom?.name
            cell.typeLabel.text = ""
            return cell
        case 1:
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCollectionViewCell", for: indexPath) as! TitleCollectionViewCell
                cell.titleLabel.text = "Открытые комнаты"
                return cell
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomCollectionViewCell", for: indexPath) as! RoomCollectionViewCell
            let room = viewModel?.openRooms[indexPath.row - 1]
            cell.titleLabel.text = room?.name
            cell.typeLabel.text = room?.roomType == .private ? "Приватная" : "Публичная"
            return cell
        default:
            fatalError()
        }
    }
}

extension RoomsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: collectionView.bounds.width - 16 * 2, height: 50)
        }
        return CGSize(width: collectionView.bounds.width - 16 * 2, height: 97)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let room = viewModel?.activeRoom {
                output?.select(room: room, isActive: true)
            }
            return
        }
        if let room = viewModel?.openRooms[indexPath.row - 1] {
            output?.select(room: room, isActive: false)
        }
    }
}
