import UIKit
final class LogInFactory {
    private enum Constants {
        static let titleFontSize: CGFloat = 37
        static let textFontSize: CGFloat = 19
        static let cornerRadius: CGFloat = 15
    }
    
    func titleLabel(text: String) -> UILabel {
        let titleText = UILabel()
        titleText.text = text
        titleText.numberOfLines = 0
        titleText.lineBreakMode = .byWordWrapping
        titleText.font = UIFont.systemFont(ofSize: Constants.titleFontSize, weight: .bold)
        titleText.translatesAutoresizingMaskIntoConstraints = false
        return titleText
    }
    
    func registerButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Зарегистрироваться", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.textFontSize, weight: .regular)
        button.backgroundColor = .clear
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.cornerRadius = Constants.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func textLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.textColor = .systemGray
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: Constants.textFontSize, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func errorLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .systemRed
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: Constants.textFontSize, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func registrationTextField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = "Введите данные"
        textField.backgroundColor = UIColor.secondarySystemBackground
        textField.layer.cornerRadius = Constants.cornerRadius
        textField.setLeftPaddingPoints(15)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    func logInButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.textFontSize, weight: .regular)
        button.backgroundColor = UIColor.ColorPalette.acсentColor
        button.layer.cornerRadius = Constants.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func backButton() -> UIButton {
        let button = UIButton()
        let img = UIImage(systemName: "arrow.left")
        img?.withTintColor(.systemBlue)
        button.setImage(img, for: .normal)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
