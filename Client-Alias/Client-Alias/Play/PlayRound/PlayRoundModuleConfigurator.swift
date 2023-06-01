import UIKit

final class PlayRoundModuleConfigurator {
    // MARK: - Configure

    func configure(
        room: PlayRoundInfo,
        words: [String],
        output: PlayRoundModuleOutput? = nil
    ) -> (
        view: PlayRoundViewController,
        input: PlayRoundModuleInput
    ) {
        let view = PlayRoundViewController()
        let presenter = PlayRoundPresenter(words: words, worker: PlayWorkerImpl(storage: SecureSettingsKeeperImpl()), room: room)
        let router = PlayRoundRouter()

        presenter.view = view
        presenter.router = router
        presenter.output = output

        router.view = view

        view.output = presenter

        return (view, presenter)
    }
}
