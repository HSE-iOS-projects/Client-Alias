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
        router?.initCoordinator(roomId: room.roomID)
        getInfo()
    }

    func update() {
        getInfo()
    }
    func select(user: Participants) {
        guard let participantID = user.id else {
            return
        }
        if room.isAdmin {
            router?.showUserActions(
                user: user.name,
                isAdmin: user.name == ProfilePresenter.userInfo.name,
                addHandler: { [weak self] in
                    self?.router?.showTeams(participantID: participantID, teams: self?.view?.viewModel?.teams ?? [])
                }, adminHandler: { [weak self] in
                    self?.passAdminStatus(participantID: participantID)
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
        router?.showMembers(
            model:
                MembersModel(
                    adminName: room.isAdmin ? ProfilePresenter.userInfo.name : nil,
                    currentTeam: team,
                    teams: view?.viewModel?.teams ?? []
                )
        )
    }

    func addTeam() {
        router?.showAddTeam(roomId: room.roomID)
    }

    func start() {
        checkGameSettings()
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
    
    private func checkGameSettings() {
        guard let teams = view?.viewModel?.teams else {
            router?.showAlert()
            return
        }
        if teams.count < 2 {
            router?.showAlert(title: "А где команды?", message: "Для игры должно быть минимум 2 команды с участниками")
        } else {
            var count = 0
            for team in teams {
                if team.participants.isEmpty {
                    router?.showAlert(title: "Пустая команда: \(team.name)", message: "Удалите пустые команды")
                    return
                } else {
                    count += 1
                }
            }
            
            if count < 2 {
                router?.showAlert(title: "А где команды?", message: "Для игры должно быть минимум 2 команды с участниками")
                return
            }
        }
        
        router?.showGameSettings(roomID: room.roomID)
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
    
    private func passAdminStatus(participantID: UUID) {
        worker.passAdminStatus(request: PassAdminStatusRequest(userID: participantID, roomID: room.roomID)) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.view?.viewModel?.room.isAdmin = false
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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
