import UIKit

class MainFactory {

    static func makeTextView() -> UITextView {
        let textView = UITextView()
        textView.textColor = .white
        textView.backgroundColor = UIColor(red: 28 / 255, green: 28 / 255, blue: 30 / 255, alpha: 1)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }

    static func makeLabel(text: String, cornerRadius: CGFloat? = nil) -> UILabel {
        let titleLabel = UILabel()
        if let cornerRadius {
            titleLabel.layer.cornerRadius = cornerRadius
        }
        titleLabel.textColor = .gray
        titleLabel.text = text
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }
    
    static func makeTextField(text: String, mainText: String? = nil) -> UITextField {
        let textField = UITextField()
        textField.textColor = .white
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(red: 28 / 255, green: 28 / 255, blue: 30 / 255, alpha: 1)
        if let mainText {
            textField.text = mainText
        }
        textField.placeholder = text
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
}
