import UIKit

final class GameCoordinator: WebSocketObserver {
    
    let navigationController: UINavigationController?
    let k = MainWorkerImpl(storage: SecureSettingsKeeperImpl())
    let roomID: UUID
    
    init(navigation: UINavigationController?, roomID: UUID) {
        self.navigationController = navigation
        self.roomID = roomID
    }
    
    func receiveStartGame() {
        print("--------------start------------------")
        k.nextRound(request: NextRoundRequest(points: -1, roomID: roomID)) { result in
            switch result {
            case .success:
                print("-----suc-----")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func receiveWords(words: [String]) {
        let vc = PlayRoundModuleConfigurator().configure(roomID: roomID, words: words).view
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func receiveWaiting() {
        let vc = PlayRoundModuleConfigurator().configure(roomID: roomID, words: []).view
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func receiveWaitingForResults() {
        let viewController = EndGameModuleConfigurator().configure(
            output: nil,
            data: [WordInfo]()
        ).view
       
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    func receiveResults(result: String) {
        let viewController = ResultModuleConfigurator().configure(
            roomID: roomID, 
            result: result
        ).view
        navigationController?.pushViewController(viewController, animated: false)
    }    
}
