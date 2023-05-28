import Foundation

enum MainEndpoint: Endpoint {
    
    case createRoom
    case getAllRooms
    case joinRoom
    
    var compositPath: String {
        switch self {
        case .createRoom:
            return "/game/create"
        case .getAllRooms:
            return "/game/getAllRooms"
        case .joinRoom:
            return "/game/joinRoom"
        }
    }
}
