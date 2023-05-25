import UIKit

final class ResultModuleConfigurator {
    // MARK: - Configure

    func configure(
        output: ResultModuleOutput? = nil
    ) -> (
        view: ResultViewController,
        input: ResultModuleInput
    ) {
        let view = ResultViewController()
        let presenter = ResultPresenter()
        let router = ResultRouter()

        presenter.view = view
        presenter.router = router
        presenter.output = output

        router.view = view

        view.output = presenter

        return (view, presenter)
    }
}
