import UIKit

final class TeamsModuleConfigurator {
    // MARK: - Configure

    func configure(
        output: TeamsModuleOutput? = nil
    ) -> (
        view: TeamsViewController,
        input: TeamsModuleInput
    ) {
        let view = TeamsViewController()
        let presenter = TeamsPresenter()
        let router = TeamsRouter()

        presenter.view = view
        presenter.router = router
        presenter.output = output

        router.view = view

        view.output = presenter

        return (view, presenter)
    }
}
