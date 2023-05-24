import UIKit

final class AuthorizationModuleConfigurator {
    
    // MARK: - Configure

    func configure(
        output: AuthorizationModuleOutput? = nil
    ) -> (
        view: AuthorizationViewController,
        input: AuthorizationModuleInput
    ) {
        let view = AuthorizationViewController()
        let presenter = AuthorizationPresenter(worker: AuthorizationWorkerImpl())
        let router = AuthorizationRouter()

        presenter.view = view
        presenter.router = router
        presenter.output = output

        router.view = view

        view.output = presenter

        return (view, presenter)
    }
}
