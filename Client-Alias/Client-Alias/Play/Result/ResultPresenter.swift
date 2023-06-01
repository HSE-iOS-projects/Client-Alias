import Foundation
protocol ResultModuleInput: AnyObject {}

protocol ResultModuleOutput: AnyObject {}

final class ResultPresenter {
    // MARK: - Properties

    weak var view: ResultViewInput?
    var router: ResultRouterInput?
    weak var output: ResultModuleOutput?

    let resultStatus: String
    let worker: PlayWorker
    let roomID: UUID

    init(res: String, worker: PlayWorker, roomID: UUID) {
        resultStatus = res
        self.worker = worker
        self.roomID = roomID
    }
}

// MARK: - ResultViewOutput

extension ResultPresenter: ResultViewOutput {
    func viewDidLoad() {
        if resultStatus == "You win" {
            view?.showInfo(winner: "Поздравляем, вы выиграли")
        } else {
            view?.showInfo(winner: "К сожалению, вы проиграли")
        }
    }

    func openMain() {
        worker.endGame(request: EndGame(roomID: roomID)) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success:
                self.worker.leaveRoom { res in
                    switch res {
                    case .success:
                        print("delete successfully")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

        router?.openMain()
    }
}

// MARK: - ResultInput

extension ResultPresenter: ResultModuleInput {}
