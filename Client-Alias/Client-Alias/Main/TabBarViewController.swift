import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [RoomsModuleConfigurator().configure().view,
                           ProfileModuleConfigurator().configure().view]
    }
}
