import UIKit

final class EndGameModuleConfigurator {
    // MARK: - Configure

    func configure(
        output: EndGameModuleOutput? = nil,
        data: [WordInfo]
    ) -> (
        view: EndGameViewController,
        input: EndGameModuleInput
    ) {
        let view = EndGameViewController()
        let presenter = EndGamePresenter(data: data)
        let router = EndGameRouter()

        presenter.view = view
        presenter.router = router
        presenter.output = output

        router.view = view

        view.output = presenter

        return (view, presenter)
    }
}
