import Foundation

struct Room {

    enum RoomType {
        case `private`
        case `public`
    }

    let name: String
    let roomType: RoomType
}

struct UserRooms {
    let activeRoom: Room?
    let openRooms: [Room]
}
