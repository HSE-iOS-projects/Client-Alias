import UIKit

final class RoomsModuleConfigurator {
    // MARK: - Configure

    func configure(
        output: RoomsModuleOutput? = nil
    ) -> (
        view: RoomsViewController,
        input: RoomsModuleInput
    ) {
        let view = RoomsViewController()
        let presenter = RoomsPresenter()
        let router = RoomsRouter()

        presenter.view = view
        presenter.router = router
        presenter.output = output

        router.view = view

        view.output = presenter

        return (view, presenter)
    }
}
