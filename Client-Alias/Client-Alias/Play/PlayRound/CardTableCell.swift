import UIKit

final class CardTableCell: UITableViewCell {
    
    static let reuseIdentifier = "CardTableCell"
    var tapHandler: ((_ value: Int, _ index: Int) -> Void)?
    
    private let wordsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stepper: CustomStepper = {
        let step = CustomStepper()
        step.currentValue = 1
        step.translatesAutoresizingMaskIntoConstraints = false
        return step
    }()
    
    private let placeHolder: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var index = 0
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(data: WordInfo?) {
        wordsLabel.text = data?.word ?? ""
        stepper.currentValue = data?.value ?? 0
        index = data?.index ?? 0
    }
    
    private func setupUI() {
        contentView.addSubview(placeHolder)
        contentView.addSubview(stepper)
        contentView.addSubview(wordsLabel)
        stepper.addTarget(self, action: #selector(stepperChangedValueAction), for: .valueChanged)
        NSLayoutConstraint.activate([
            placeHolder.leadingAnchor.constraint(equalTo: leadingAnchor),
            placeHolder.trailingAnchor.constraint(equalTo: trailingAnchor),
            placeHolder.centerYAnchor.constraint(equalTo: centerYAnchor),
            placeHolder.heightAnchor.constraint(equalToConstant: 50),
            
            wordsLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            wordsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            wordsLabel.heightAnchor.constraint(equalToConstant: 20),
            
            stepper.centerYAnchor.constraint(equalTo: centerYAnchor),
            stepper.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
    }
    
    @objc
    private func stepperChangedValueAction(sender: CustomStepper) {
        tapHandler?(sender.currentValue, index)
    }
}
