import UIKit

extension UIAlertController {

        static func makeProblemAlert(anchoredBarButtonItem: UIBarButtonItem?) -> UIAlertController {
            let controller = UIAlertController(title: "Ууупс", message: "Что-то пошло не так", preferredStyle: .alert)
            
            controller.addAction(.init(title: "Добро", style: .default))

            controller.popoverPresentationController?.barButtonItem = anchoredBarButtonItem

            return controller
        }
}
