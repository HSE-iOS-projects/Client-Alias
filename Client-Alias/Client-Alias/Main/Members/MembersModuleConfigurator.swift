import UIKit

final class MembersModuleConfigurator {
    // MARK: - Configure

    func configure(
        model: MembersModel,
        output: MembersModuleOutput? = nil
    ) -> (
        view: MembersViewController,
        input: MembersModuleInput
    ) {
        let view = MembersViewController()
        let presenter = MembersPresenter(
            model: model,
            worker: MainWorkerImpl(storage: SecureSettingsKeeperImpl())
        )
        let router = MembersRouter()

        presenter.view = view
        presenter.router = router
        presenter.output = output

        router.view = view

        view.output = presenter

        return (view, presenter)
    }
}
