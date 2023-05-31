import Foundation

struct RoomInfoViewModel: Equatable {

    var room: Room
    let isMyTeam: Bool
    var teams: [TeamInfo]
    var noTeamUsers: [Participants]

    init(room: Room, team: [TeamInfo]) {
        self.room = room
        isMyTeam = false
        teams = team
        noTeamUsers = []
    }
    
    init(room: Room, team: [TeamInfo], noTeamUsers: [Participants]) {
        self.room = room
        isMyTeam = false
        teams = team
        self.noTeamUsers = noTeamUsers
    }

    static func == (lhs: RoomInfoViewModel, rhs: RoomInfoViewModel) -> Bool {
        lhs.room == rhs.room &&
        lhs.isMyTeam == rhs.isMyTeam &&
        lhs.teams == rhs.teams &&
        lhs.noTeamUsers == rhs.noTeamUsers
    }
}
