import UIKit
class WaitCardView: UIView {
    
    private let wordLabel: UILabel = {
        let titleText = UILabel()
        titleText.numberOfLines = 0
        titleText.textColor = .white
        titleText.text = "Ожидание"
        titleText.font = UIFont.systemFont(ofSize: 37, weight: .bold)
        return titleText
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setup() {
        backgroundColor = .secondarySystemBackground
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 1.5)
        layer.shadowRadius = 4.0
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.cornerRadius = 10.0
        addSubview(wordLabel)
        
        wordLabel.frame = CGRect(
            x: (frame.width - wordLabel.intrinsicContentSize.width) / 2,
            y: (frame.height - wordLabel.intrinsicContentSize.height) / 2,
            width: wordLabel.intrinsicContentSize.width,
            height: wordLabel.intrinsicContentSize.height
        )
    }
}
