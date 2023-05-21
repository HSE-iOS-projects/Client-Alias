import UIKit

final class ProfileModuleConfigurator {
    // MARK: - Configure

    func configure(
        output: ProfileModuleOutput? = nil
    ) -> (
        view: ProfileViewController,
        input: ProfileModuleInput
    ) {
        let view = ProfileViewController()
        let presenter = ProfilePresenter()
        let router = ProfileRouter()

        presenter.view = view
        presenter.router = router
        presenter.output = output

        router.view = view

        view.output = presenter

        return (view, presenter)
    }
}
