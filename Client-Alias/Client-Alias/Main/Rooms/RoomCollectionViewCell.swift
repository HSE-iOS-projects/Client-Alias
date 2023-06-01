import UIKit

class RoomCollectionViewCell: UICollectionViewCell {

    private(set) lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Название"
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 20)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()

    private(set) lazy var typeLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Private"
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(typeLabel)

        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 15

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 21),

            typeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            typeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            typeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
