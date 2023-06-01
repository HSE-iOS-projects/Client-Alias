import Foundation

struct ResultInfo {
    let winner: TeamResultInfo
    let allTeams: [TeamResultInfo]
}

struct TeamResultInfo {
    let name: String
    let result: Int
}
