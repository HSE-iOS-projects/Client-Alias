import UIKit

class TitleCollectionViewCell: UICollectionViewCell {

    var tapHandler: (() -> Void)?

    private(set) lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Название"
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 30)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()

    private(set) lazy var actionButton: UIButton = {
        let actionButton = UIButton()
        actionButton.isHidden = true
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.addTarget(self, action: #selector(tap), for: .touchUpInside)
        return actionButton
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(actionButton)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: actionButton.leadingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),

            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 44),
            actionButton.heightAnchor.constraint(equalToConstant: 44),
            actionButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func tap() {
        tapHandler?()
    }
}
