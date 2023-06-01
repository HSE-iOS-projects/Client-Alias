import Foundation
enum PlayEndpoint: Endpoint {
    case endGame
    case nextRound
    
    var compositPath: String {
        switch self {
        case .nextRound:
            return "/game/nextRound"
        case .endGame:
            return "/game/endGame"
        }
    }
}
