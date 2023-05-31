import Foundation

enum MainEndpoint: Endpoint {
    
    case createRoom
    case getAllRooms
    case joinRoom
    case getRoomParticipants(roomID: String)
    case getMyInfo
    case createTeam
    case passAdminStatus
    case deleteUserFromRoomRequest
    case leaveRoomRequest
    case addToTeamRequest
    case getRoomInfo
    case deleteTeam
    case startGame
    
    var compositPath: String {
        switch self {
        case .createRoom:
            return "/game/create"
        case .getAllRooms:
            return "/game/getAllRooms"
        case .joinRoom:
            return "/game/joinRoom"
        case let .getRoomParticipants(roomID: roomID):
            return "/game/\(roomID)"
        case .getMyInfo:
            return "/game/getMe"
        case .createTeam:
            return "/game/createTeamRequest"
        case .passAdminStatus:
            return "/game/passAdminStatus"
        case .deleteUserFromRoomRequest:
            return "/game/deleteUserFromRoomRequest"
        case .leaveRoomRequest:
            return "/game/leaveRoomRequest"
        case .addToTeamRequest:
            return "/game/addToTeam"
        case .getRoomInfo:
            return "/game/getRoomInfo"
        case .deleteTeam:
            return "/game/deleteTeam"
        case .startGame:
            return "/game/startGame"
        }
    }
}
