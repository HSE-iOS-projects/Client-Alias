import Foundation
protocol RoomInfoModuleInput: AnyObject {}

protocol RoomInfoModuleOutput: AnyObject {}

final class RoomInfoPresenter {
    // MARK: - Properties

    weak var view: RoomInfoViewInput?
    var router: RoomInfoRouterInput?
    weak var output: RoomInfoModuleOutput?

    let worker: MainWorker
    var room: Room

    init(worker: MainWorker, room: Room) {
        self.worker = worker
        self.room = room
    }
}

// MARK: - RoomInfoViewOutput

extension RoomInfoPresenter: RoomInfoViewOutput {

    func viewDidLoad() {
        getInfo()
    }

    func select(user: Participants) {
        guard let participantID = user.id else {
            return
        }
        if room.isAdmin {
            router?.showUserActions(
                user: user.name,
                addHandler: { [weak self] in
                    self?.router?.showTeams()
                }, adminHandler: {
                    
                }, deleteHandler: { [weak self] in
                    self?.deleteUser(teamId: user.teamID, participantID: participantID)
                }
            )
        }
    }

    func showTeamMenu(team: TeamInfo) {
        guard let id = team.teamID else {
            return
        }
        if room.isAdmin {
            router?.showTeamActions(team: team.name, deleteHandler: { [weak self] in
                self?.worker.deleteTeam(request: DeleteRoomRequest(id: id), completion: { [weak self] result in
                    switch result {
                    case .success:
                        self?.getInfo()
                    case .failure(let error):
                        print(error.localizedDescription)
                        print("Не удалилось....")
                    }
                })
            })
        }
    }
    

    func select(team: TeamInfo) {
        router?.showMembers()
    }

    func addTeam() {
        router?.showAddTeam(roomId: room.roomID)
    }

    func start() {
        router?.showGameSettings()
    }

    func leaveRoom() {
        worker.leaveRoom { result in
            switch result {
            case .success:
                print("вышел из комнаты")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getInfo() {
        worker.getRoomInfo(request: GetRoomInfoRequest(id: room.roomID)) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    let newdata = self.createRoomInfo(data: success)
                    self.view?.viewModel = newdata
                    self.room = newdata.room
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    private func createRoomInfo(data: GetRoomInfoResponse) -> RoomInfoViewModel {
        var teams = [TeamInfo]()

        for team in data.teams {
            teams.append(TeamInfo(
                teamID: team.id,
                name: team.name,
                participants: []
            ))
        }

        var roomInfo = RoomInfoViewModel(
            room: Room(
                roomID: data.id,
                name: data.name,
                roomType: .public,
                url: data.url,
                code: data.key,
                isAdmin: data.isAdmin
            ),
            team: teams
        )

        for player in data.participants {
            if player.teamId == nil {
                roomInfo.noTeamUsers.append(
                    Participants(
                        id: player.id,
                        name: player.name,
                        userID: nil,
                        roomID: data.id
                    )
                )
            } else {
                let index = roomInfo.teams.firstIndex { team in
                    team.teamID == player.teamId
                }
                if let index = index {
                    roomInfo.teams[index].participants.append(
                        Participants(
                            id: player.id,
                            name: player.name,
                            userID: nil,
                            roomID: data.id
                        ))
                }
            }
        }

        return roomInfo
    }
    
    
    private func deleteUser(teamId: UUID?, participantID: UUID) {
        worker.deleteUserFromRoom(
            request:
            DeleteUserFromRoomRequest(
                participantID: participantID,
                roomID: room.roomID
            )
        ) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
                
            case .success:
                DispatchQueue.main.async {
                    var teams = self.view?.viewModel?.teams
                    var users = self.view?.viewModel?.noTeamUsers

                    if let teamID = teamId {
                        users?.removeAll(where: { part in
                            part.id == participantID
                        })
                        
                        let index = teams?.firstIndex(where: { t in
                            t.teamID == teamID
                        })
                        
                        if let index {
                            teams?[index].participants.removeAll { p in
                                p.id == participantID
                            }
                        }
                    } else {
                        users?.removeAll(where: { part in
                            part.id == participantID
                        })
                    }
                    
                    self.view?.viewModel = RoomInfoViewModel(
                        room: self.room,
                        team: teams ?? [],
                        noTeamUsers: users ?? []
                    )
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - RoomInfoInput

extension RoomInfoPresenter: RoomInfoModuleInput {}
