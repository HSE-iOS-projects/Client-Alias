import UIKit

final class TeamCell: UITableViewCell {
    
    static let reuseIdentifier = "TeamCell"
    
    private let teamLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let placeHolder: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(data: TeamResultInfo?) {
        teamLabel.text = data?.name ?? ""
        resultLabel.text = String(data?.result ?? 0)
    }
    
    private func setupUI() {
        contentView.addSubview(placeHolder)
        contentView.addSubview(resultLabel)
        contentView.addSubview(teamLabel)
        
        NSLayoutConstraint.activate([
            placeHolder.leadingAnchor.constraint(equalTo: leadingAnchor),
            placeHolder.trailingAnchor.constraint(equalTo: trailingAnchor),
            placeHolder.centerYAnchor.constraint(equalTo: centerYAnchor),
            placeHolder.heightAnchor.constraint(equalToConstant: 50),
            
            teamLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            teamLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            teamLabel.heightAnchor.constraint(equalToConstant: 20),
            
            resultLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            resultLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
    }
}
