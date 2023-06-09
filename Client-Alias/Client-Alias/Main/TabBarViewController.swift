import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let rooms = RoomsModuleConfigurator().configure().view
        rooms.tabBarItem.title = "Комнаты"
        rooms.tabBarItem.image = UIImage(systemName: "square.split.bottomrightquarter")

        let profile = ProfileModuleConfigurator().configure().view
        profile.tabBarItem.title = "Профиль"
        profile.tabBarItem.image = UIImage(systemName: "person.fill")

        viewControllers = [rooms, profile]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}
