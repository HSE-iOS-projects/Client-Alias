import UIKit

final class RegistrationModuleConfigurator {
    // MARK: - Configure

    func configure(output: RegistrationModuleOutput? = nil) -> (view: RegistrationViewController,
                                                                input: RegistrationModuleInput) {
        let view = RegistrationViewController()
        let presenter = RegistrationPresenter(worker: AuthorizationWorkerImpl())
        let router = RegistrationRouter()

        presenter.view = view
        presenter.router = router
        presenter.output = output

        router.view = view

        view.output = presenter

        return (view, presenter)
    }
}
