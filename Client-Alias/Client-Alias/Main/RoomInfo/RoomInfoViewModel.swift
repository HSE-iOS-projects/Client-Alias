import Foundation

class RoomInfoViewModel: Equatable {

    let room: Room
    let isMyTeam = false
    let teams = ["Team 1", "Team 2", "Team 3", "Team 3", "Team 3", "Team 3", "Team 3", "Team 3",]
    let users = ["User 1", "User 2", "User 3", "User 3", "User 3", "User 3", "User 3", "User 3"]

    init(room: Room) {
        self.room = room
    }

    static func == (lhs: RoomInfoViewModel, rhs: RoomInfoViewModel) -> Bool {
        lhs.room == rhs.room &&
        lhs.isMyTeam == rhs.isMyTeam &&
        lhs.teams == rhs.teams &&
        lhs.users == rhs.users
    }
}
