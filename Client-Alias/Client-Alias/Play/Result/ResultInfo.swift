import Foundation

struct ResultInfo {
    let winner: TeamInfo
    let allTeams: [TeamInfo]
   
}

struct TeamInfo {
    let name: String
    let result: Int
}
