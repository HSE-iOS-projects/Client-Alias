import UIKit

protocol RoomsViewInput: AnyObject {

    func update(userRooms: UserRooms)
}

protocol RoomsViewOutput: AnyObject {
    func viewDidLoad()
    func add()
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
        collectionView.backgroundColor = .black
        return collectionView
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
//        textField.layer.cornerRadius = 16
        textField.backgroundColor = UIColor(red: 28 / 255, green: 28 / 255, blue: 30 / 255, alpha: 1)
        textField.placeholder = "Название комнаты"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var addButton: UIButton = {
        let addButton = UIButton()
        addButton.tintColor = .white
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        return addButton
    }()

    private lazy var keyButton: UIButton = {
        let keyButton = UIButton()
        keyButton.tintColor = .white
        keyButton.setImage(UIImage(systemName: "key.fill"), for: .normal)
        keyButton.translatesAutoresizingMaskIntoConstraints = false
        keyButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        return keyButton
    }()

    // MARK: - Properties

    var output: RoomsViewOutput?
    private var userRooms: UserRooms = .init(activeRoom: nil, openRooms: [])

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
        view.backgroundColor = .black
        tabBarItem.title = "Rooms"
        tabBarItem.image = UIImage(systemName: "square.split.bottomrightquarter")

        view.addSubview(textField)
        view.addSubview(addButton)
        view.addSubview(keyButton)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 32),

            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 32),
            addButton.heightAnchor.constraint(equalToConstant: 32),
            addButton.trailingAnchor.constraint(equalTo: keyButton.leadingAnchor, constant: -16),

            keyButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            keyButton.widthAnchor.constraint(equalToConstant: 32),
            keyButton.heightAnchor.constraint(equalToConstant: 32),
            keyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -16),

            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Actions

    @objc func add() {
        output?.add()
    }

    // MARK: - Setup

    private func setupUI() {}

    private func setupLocalization() {}
}

// MARK: - TroikaServiceViewInput

extension RoomsViewController: RoomsViewInput {

    func update(userRooms: UserRooms) {
        self.userRooms = userRooms
        collectionView.reloadData()
    }
}

extension RoomsViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var sections = 0
        if userRooms.activeRoom != nil {
            sections += 1
        }
        if userRooms.openRooms.count != 0 {
            sections += 1
        }
        return sections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return userRooms.activeRoom == nil ? 0 : 2
        }
        return userRooms.openRooms.count == 0 ? 0 : userRooms.openRooms.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCollectionViewCell", for: indexPath) as! TitleCollectionViewCell
            cell.titleLabel.text = indexPath.section == 0 ? "Активная комната" : "Открытые комнаты"
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomCollectionViewCell", for: indexPath) as! RoomCollectionViewCell
        if indexPath.section == 0 {
            let activeRoom = userRooms.activeRoom
            cell.titleLabel.text = activeRoom?.name
            cell.typeLabel.text = activeRoom?.roomType == .private ? "Приватная" : "Публичная"
            return cell
        }
        let room = userRooms.openRooms[indexPath.row - 1]
        cell.titleLabel.text = room.name
        cell.typeLabel.text = room.roomType == .private ? "Приватная" : "Публичная"
        return cell
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
}
