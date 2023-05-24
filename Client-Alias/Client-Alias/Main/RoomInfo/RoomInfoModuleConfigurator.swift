import UIKit

final class RoomInfoModuleConfigurator {
    // MARK: - Configure

    func configure(
        room: Room,
        output: RoomInfoModuleOutput? = nil
    ) -> (
        view: RoomInfoViewController,
        input: RoomInfoModuleInput
    ) {
        let view = RoomInfoViewController()
        let presenter = RoomInfoPresenter(room: room)
        let router = RoomInfoRouter()

        presenter.view = view
        presenter.router = router
        presenter.output = output

        router.view = view

        view.output = presenter

        return (view, presenter)
    }
}
