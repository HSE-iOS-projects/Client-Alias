import UIKit

final class RoomModuleConfigurator {
    // MARK: - Configure

    func configure(
        output: RoomModuleOutput? = nil
    ) -> (
        view: RoomViewController,
        input: RoomModuleInput
    ) {
        let view = RoomViewController()
        let storage = SecureSettingsKeeperImpl()
        let presenter = RoomPresenter(worker: MainWorkerImpl(storage: storage))
        let router = RoomRouter()

        presenter.view = view
        presenter.router = router
        presenter.output = output

        router.view = view

        view.output = presenter

        return (view, presenter)
    }
}
