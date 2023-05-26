import UIKit

class TextFieldCollectionViewCell: UICollectionViewCell {

    private(set) lazy var textView: UITextView = {
        let textView = MainFactory.makeTextView()
        textView.layer.cornerRadius = 15
        textView.text = "1234"
        textView.font = .systemFont(ofSize: 20)
        return textView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textView)

        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
