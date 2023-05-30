import Foundation

struct TeamInfo: Equatable {
    let teamID: UUID?
    let name: String
    var participants: [Participants]
    
    static func == (lhs: TeamInfo, rhs: TeamInfo) -> Bool {
        lhs.teamID == rhs.teamID
    }
}

struct Participants: Codable, Equatable {
    let id: UUID?
    let name: String
    let userID: UUID?
    let roomID: UUID
    var teamID: UUID?
    
    static func == (lhs: Participants, rhs: Participants) -> Bool {
        lhs.name == rhs.name &&
        lhs.userID == rhs.userID
    }
}
