import Foundation

// MARK: - Create Room Request

struct RoomRequest: Codable {
    let name: String
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
    let isAdmin: Bool
    let name: String
    let isOpen: Bool
    let status: String
}

struct Empty: Codable {}

// MARK: - Join Room Request
struct JoinRoomRequest: Codable {
    let roomID: UUID
    let inviteCode: String?
}
