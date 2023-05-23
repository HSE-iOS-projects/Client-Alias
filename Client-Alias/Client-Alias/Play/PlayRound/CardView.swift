import UIKit
class CardView: UIView {
    private let wordLabel: UILabel = {
        let titleText = UILabel()
        titleText.numberOfLines = 0
        titleText.textColor = .white
        titleText.font = UIFont.systemFont(ofSize: 37, weight: .bold)
        return titleText
    }()
    // TODO: - прокинуть действие измениния
    private let settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "line.horizontal.3.decrease"), for: .normal)
        button.menu = UIMenu(title: "", options: .displayInline, children: [
            UIAction(title: "Легко", handler: { _ in }),
            UIAction(title: "Нормально", state: .on, handler: { _ in }),
            UIAction(title: "Сложно", handler: { _ in }),
            UIAction(title: "Очень сложно", handler: { _ in }),
        ])
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func config(text: String, color: UIColor) {
        wordLabel.text = text
        backgroundColor = color
        settingsButton.isHidden = true
        setup()
    }

    func setup() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 1.5)
        layer.shadowRadius = 4.0
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.cornerRadius = 10.0
        addSubview(wordLabel)
        addSubview(settingsButton)
        wordLabel.frame = CGRect(
            x: (frame.width - wordLabel.intrinsicContentSize.width) / 2,
            y: (frame.height - wordLabel.intrinsicContentSize.height) / 2,
            width: wordLabel.intrinsicContentSize.width,
            height: wordLabel.intrinsicContentSize.height
        )
        
        settingsButton.frame = CGRect(
            x: frame.width - 40,
            y: 15,
            width: 25,
            height: 25
        )
        settingsButton.isHidden = false
    }
}
