import UIKit

final class GameSettingsModuleConfigurator {
    // MARK: - Configure

    func configure(
        output: GameSettingsModuleOutput? = nil
    ) -> (
        view: GameSettingsViewController,
        input: GameSettingsModuleInput
    ) {
        let view = GameSettingsViewController()
        let presenter = GameSettingsPresenter()
        let router = GameSettingsRouter()

        presenter.view = view
        presenter.router = router
        presenter.output = output

        router.view = view

        view.output = presenter

        return (view, presenter)
    }
}
