import UIKit

final class ResultModuleConfigurator {
    // MARK: - Configure

    func configure(
        roomID: UUID,
        result: String,
        output: ResultModuleOutput? = nil
    ) -> (
        view: ResultViewController,
        input: ResultModuleInput
    ) {
        let view = ResultViewController()
        let presenter = ResultPresenter(res: result, worker: PlayWorkerImpl(storage: SecureSettingsKeeperImpl()), roomID: roomID)
        let router = ResultRouter()

        presenter.view = view
        presenter.router = router
        presenter.output = output

        router.view = view

        view.output = presenter

        return (view, presenter)
    }
}
