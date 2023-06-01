import UIKit

final class GameSettingsModuleConfigurator {
    // MARK: - Configure

    func configure(
        roomID: UUID,
        output: GameSettingsModuleOutput? = nil
    ) -> (
        view: GameSettingsViewController,
        input: GameSettingsModuleInput
    ) {
        let view = GameSettingsViewController()
        let presenter = GameSettingsPresenter(
            worker: MainWorkerImpl(storage: SecureSettingsKeeperImpl()),
            roomID: roomID)
        let router = GameSettingsRouter()

        presenter.view = view
        presenter.router = router
        presenter.output = output

        router.view = view

        view.output = presenter

        return (view, presenter)
    }
}
