import UIKit

final class MembersModuleConfigurator {
    // MARK: - Configure

    func configure(
        output: MembersModuleOutput? = nil
    ) -> (
        view: MembersViewController,
        input: MembersModuleInput
    ) {
        let view = MembersViewController()
        let presenter = MembersPresenter()
        let router = MembersRouter()

        presenter.view = view
        presenter.router = router
        presenter.output = output

        router.view = view

        view.output = presenter

        return (view, presenter)
    }
}
