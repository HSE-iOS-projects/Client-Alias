import Foundation

struct Room: Equatable {

    enum RoomType {
        case `private`
        case `public`
    }

    let roomID: UUID 
    let name: String
    let roomType: RoomType
    let url: String
    let code: String?
}

struct UserRooms {
    let activeRoom: Room?
    let openRooms: [Room]
}
