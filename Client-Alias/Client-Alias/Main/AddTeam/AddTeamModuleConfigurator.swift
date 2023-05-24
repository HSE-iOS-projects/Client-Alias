import UIKit

final class AddTeamModuleConfigurator {
    // MARK: - Configure

    func configure(
        output: AddTeamModuleOutput? = nil
    ) -> (
        view: AddTeamViewController,
        input: AddTeamModuleInput
    ) {
        let view = AddTeamViewController()
        let presenter = AddTeamPresenter()
        let router = AddTeamRouter()

        presenter.view = view
        presenter.router = router
        presenter.output = output

        router.view = view

        view.output = presenter

        return (view, presenter)
    }
}
