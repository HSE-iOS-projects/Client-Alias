import UIKit

final class AddKeyModuleConfigurator {
    // MARK: - Configure

    func configure(
        output: AddKeyModuleOutput? = nil
    ) -> (
        view: AddKeyViewController,
        input: AddKeyModuleInput
    ) {
        let view = AddKeyViewController()
        let presenter = AddKeyPresenter()
        let router = AddKeyRouter()

        presenter.view = view
        presenter.router = router
        presenter.output = output

        router.view = view

        view.output = presenter

        return (view, presenter)
    }
}
