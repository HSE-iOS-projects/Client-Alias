import Foundation

protocol MembersModuleInput: AnyObject {}

protocol MembersModuleOutput: AnyObject {}

final class MembersPresenter {
    // MARK: - Properties

    weak var view: MembersViewInput?
    var router: MembersRouterInput?
    weak var output: MembersModuleOutput?
    
//    var adminName: String?
//    var teams: TeamInfo
    var model: MembersModel
    let worker: MainWorker
    
//    var hasChanges: Bool = false
    
    init(model: MembersModel, worker: MainWorker) {
        self.model = model
        self.worker = worker
    }
}

// MARK: - MembersViewOutput

extension MembersPresenter: MembersViewOutput {
    
    func viewDidLoad() {}
    
    func select(user: Participants) {
        guard let participantID = user.id

        else {
            return
        }
        if let adminName = model.adminName {
            router?.showUserActions(
                user: user.name,
                isAdmin: adminName == user.name ? true : false,
                addHandler: { [weak self] in
                    self?.router?.showTeams(participantID: participantID, teams: self?.model.teams ?? [])
                }, adminHandler: { [weak self] in
                    self?.passAdminStatus(participantID: participantID, name: user.name, roomId: user.roomID)
                    
                }, deleteHandler: { [weak self] in
                    self?.deleteUser(teamId: self?.model.currentTeam.teamID, participantID: participantID, roomId: user.roomID)
                }
            )
        }
    }
    
    func getCount() -> Int {
        model.currentTeam.participants.count
    }
    
    func getInfo(index: Int) -> Participants {
        model.currentTeam.participants[index]
    }
    
    func schowAction() -> Bool {
        if model.adminName != nil {
            return true
        } else {
            return false
        }
    }
    
    func deleteUser(id: UUID?) {
        model.currentTeam.participants.removeAll { item in
            item.id == id
        }
        self.view?.reloadCollectionView()
//        self.hasChanges = true
    }
    
    private func passAdminStatus(participantID: UUID, name: String, roomId: UUID) {
        worker.passAdminStatus(request: PassAdminStatusRequest(userID: participantID, roomID: roomId)) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.model.adminName = nil
                    self.view?.reloadCollectionView()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func deleteUser(teamId: UUID?, participantID: UUID, roomId: UUID) {
        worker.deleteUserFromRoom(
            request: DeleteUserFromRoomRequest(
                participantID: participantID,
                roomID: roomId
            )
        ) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.model.currentTeam.participants.removeAll { item in
                        item.id == participantID
                    }
                    
                    self.view?.reloadCollectionView()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - MembersInput

extension MembersPresenter: MembersModuleInput {}
