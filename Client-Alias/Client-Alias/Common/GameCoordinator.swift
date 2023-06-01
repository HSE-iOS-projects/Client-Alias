import UIKit

final class GameCoordinator: WebSocketObserver {
    
    let navigationController: UINavigationController?
    let k = MainWorkerImpl(storage: SecureSettingsKeeperImpl())
    let room: PlayRoundInfo
    var round = 0
    
    init(navigation: UINavigationController?, room: PlayRoundInfo) {
        self.navigationController = navigation
        self.room = room
    }
    
    func receiveStartGame() {
        print("--------------start------------------")
        k.nextRound(request: NextRoundRequest(points: -1, roomID: room.roomID)) { result in
            switch result {
            case .success:
                print("-----suc-----")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func receiveWords(words: [String]) {
        let vc = PlayRoundModuleConfigurator().configure(room: room, words: words).view
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func receiveWaiting() {
        let vc = PlayRoundModuleConfigurator().configure(room: room, words: []).view
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
            roomID: room.roomID, 
            result: result
        ).view
        navigationController?.pushViewController(viewController, animated: false)
    }    
}
