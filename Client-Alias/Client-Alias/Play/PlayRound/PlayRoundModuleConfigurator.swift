import UIKit

final class PlayRoundModuleConfigurator {
    // MARK: - Configure

    func configure(
        output: PlayRoundModuleOutput? = nil
    ) -> (
        view: PlayRoundViewController,
        input: PlayRoundModuleInput
    ) {
        let view = PlayRoundViewController()
        let presenter = PlayRoundPresenter()
        let router = PlayRoundRouter()

        presenter.view = view
        presenter.router = router
        presenter.output = output

        router.view = view

        view.output = presenter

        return (view, presenter)
    }
}
