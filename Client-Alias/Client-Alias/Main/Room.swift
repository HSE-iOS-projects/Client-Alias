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
    var isAdmin: Bool
    
    init(roomID: UUID, name: String) {
        self.roomID = roomID
        self.name = name
        self.roomType = .private
        url = ""
        code = ""
        isAdmin = false
    }
    
    init(roomID: UUID, name: String, roomType: RoomType, url: String, code: String?, isAdmin: Bool) {
        self.roomID = roomID
        self.name = name
        self.roomType = roomType
        self.url = url
        self.code = code
        self.isAdmin = isAdmin
    }
    
}

struct UserRooms {
    let activeRoom: Room?
    let openRooms: [Room]
}
