import UIKit

class MainFactory {

    static func makeTextView() -> UITextView {
        let textView = UITextView()
        textView.textColor = .label
        textView.backgroundColor = .secondarySystemBackground
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }

    static func makeLabel(text: String, cornerRadius: CGFloat? = nil) -> UILabel {
        let titleLabel = UILabel()
        if let cornerRadius {
            titleLabel.layer.cornerRadius = cornerRadius
        }
        titleLabel.textColor = .label
        titleLabel.text = text
        titleLabel.font = .boldSystemFont(ofSize: 19)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }
    
    static func makeTextField(text: String, mainText: String? = nil) -> UITextField {
        let textField = UITextField()
        textField.textColor = .label
        textField.layer.cornerRadius = 15
        textField.backgroundColor = .secondarySystemBackground
        if let mainText {
            textField.text = mainText
        }
        textField.setLeftPaddingPoints(15)
        textField.placeholder = text
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
}
