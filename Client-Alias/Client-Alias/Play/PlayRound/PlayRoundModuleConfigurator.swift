import UIKit

final class PlayRoundModuleConfigurator {
    // MARK: - Configure

    func configure(
        roomID: UUID,
        words: [String],
        output: PlayRoundModuleOutput? = nil
    ) -> (
        view: PlayRoundViewController,
        input: PlayRoundModuleInput
    ) {
        let view = PlayRoundViewController()
        let presenter = PlayRoundPresenter(words: words, worker: PlayWorkerImpl(storage: SecureSettingsKeeperImpl()), roomID: roomID)
        let router = PlayRoundRouter()

        presenter.view = view
        presenter.router = router
        presenter.output = output

        router.view = view

        view.output = presenter

        return (view, presenter)
    }
}
