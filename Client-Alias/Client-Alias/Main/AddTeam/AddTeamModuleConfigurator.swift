import UIKit

final class AddTeamModuleConfigurator {
    // MARK: - Configure

    func configure(
        roomId: UUID,
        output: AddTeamModuleOutput? = nil
    ) -> (
        view: AddTeamViewController,
        input: AddTeamModuleInput
    ) {
        let view = AddTeamViewController()
        let presenter = AddTeamPresenter(worker: MainWorkerImpl(storage: SecureSettingsKeeperImpl()), roomID: roomId)
        let router = AddTeamRouter()

        presenter.view = view
        presenter.router = router
        presenter.output = output

        router.view = view

        view.output = presenter

        return (view, presenter)
    }
}
