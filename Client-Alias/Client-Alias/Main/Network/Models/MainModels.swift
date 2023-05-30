import Foundation

// MARK: - Create Room Request

struct RoomRequest: Codable {
    let name: String
    let url: String
    let is_open: Bool
}

// MARK: - Create Room Response

struct RoomResponse: Codable {
    let roomID: UUID
    let roomName: String
    let inviteCode: String?
}


// MARK: - ALl Rooms Response

struct AllRoomsResponse: Codable {
    let roomID: UUID
    let isActivRoom: Bool
    let url: String
    let isAdmin: Bool
    let name: String
    let isOpen: Bool
    let status: String
}

struct Empty: Codable {}

// MARK: - Join Room Request

struct JoinRoomRequest: Codable {
    let roomID: UUID?
    let inviteCode: String?
}


// MARK: - Get my info Response

struct MeResponse: Codable {
    let nickname: String
    let roomID: UUID?
    let roomName: String?
}

// MARK: - Create team Request

struct TeamRequest: Codable {
    let roomID: UUID
    let name: String
    var totalPoints: Int = 0
    var round: Int = 0
}

// MARK: - Get Room Info Request

struct GetRoomInfoRequest: Codable {
    let id: UUID
}

// MARK: - Get Room Info Response

struct GetRoomInfoResponse: Codable {
    let name: String
    let id: UUID
    let participants: [UserInGame]
    let teams: [Team]
    let url: String
    let isAdmin: Bool
    let key: String?
}

struct UserInGame: Codable {
    let id: UUID
    let name: String
    let teamId: UUID?
    let team: String?
}

struct Team: Codable {
    let id: UUID?
    let roomID: UUID
    var name: String
    var round: Int
    var totalPoints: Int
}

// MARK: - Pass Admin Status Request

struct PassAdminStatusRequest: Codable {
    let userID: UUID
    let roomID: UUID
}

// MARK: - Delete User From Room Request

struct DeleteUserFromRoomRequest: Codable {
    let participantID: UUID
    let roomID: UUID
}


// MARK: - Add User To Team Request

struct AddUserToTeamRequest: Codable {
    let userID: UUID
    let teamID: UUID
}


// MARK: - Delete Team Request

struct DeleteRoomRequest: Codable {
    let id: UUID
}
