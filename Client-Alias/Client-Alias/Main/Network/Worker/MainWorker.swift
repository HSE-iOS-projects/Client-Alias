import Foundation

protocol MainWorker {
    func createRoom(request: RoomRequest, completion: @escaping (Result<RoomResponse, Error>) -> Void)
    func getAllRooms(completion: @escaping (Result<[AllRoomsResponse], Error>) -> Void)
    func getRoomInfo(request: GetRoomInfoRequest, completion: @escaping (Result<GetRoomInfoResponse, Error>) -> Void)
    func getMyInfo(completion: @escaping (Result<MeResponse, Error>) -> Void)
    func createTeam(request: TeamRequest, completion: @escaping (VoidResult) -> Void)
    func joinRoom(request: JoinRoomRequest, completion: @escaping (Result<GetRoomInfoResponse, Error>) -> Void)
    func passAdminStatus(request: PassAdminStatusRequest, completion: @escaping (VoidResult) -> Void)
    func deleteUserFromRoom(request: DeleteUserFromRoomRequest, completion: @escaping (VoidResult) -> Void)
    func leaveRoom(completion: @escaping (VoidResult) -> Void)
    func addToTeam(request: AddUserToTeamRequest, completion: @escaping (VoidResult) -> Void)
    func deleteTeam(request: DeleteRoomRequest, completion: @escaping (VoidResult) -> Void)
    func startGame(request: StartGameRequest, completion: @escaping (VoidResult) -> Void)
    func nextRound(request: NextRoundRequest, completion: @escaping (VoidResult) -> Void)
    func deleteUser(completion: @escaping (VoidResult) -> Void)
    func changeRoomStatus(request: ChangeRoomStateRequest, completion: @escaping (Result<ChangeRoomStateResponse, Error>) -> Void)
}

final class MainWorkerImpl: MainWorker {
    let storage: SecureSettingsKeeper
    
    init(storage: SecureSettingsKeeper) {
        self.storage = storage
    }
    
    private let networking = Networking(baseURL: "http://127.0.0.1:8080")

    func createRoom(request: RoomRequest, completion: @escaping (Result<RoomResponse, Error>) -> Void) {
        let endpoint = MainEndpoint.createRoom
        fetch(endpoint: endpoint, body: request, method: .post, completion: completion)
    }
    
    func getAllRooms(completion: @escaping (Result<[AllRoomsResponse], Error>) -> Void) {
        let endpoint = MainEndpoint.getAllRooms
        fetch(endpoint: endpoint, body: Empty(), method: .get, completion: completion)
    }
    
    func getRoomInfo(request: GetRoomInfoRequest, completion: @escaping (Result<GetRoomInfoResponse, Error>) -> Void) {
        let endpoint = MainEndpoint.getRoomInfo
        fetch(endpoint: endpoint, body: request, method: .post, completion: completion)
    }
    
    func getMyInfo(completion: @escaping (Result<MeResponse, Error>) -> Void) {
        let endpoint = MainEndpoint.getMyInfo
        fetch(endpoint: endpoint, body: Empty(), method: .get, completion: completion)
    }
    
    func createTeam(request: TeamRequest, completion: @escaping (VoidResult) -> Void) {
        let endpoint = MainEndpoint.createTeam
        fetch(endpoint: endpoint, body: request, method: .post, completion: completion)
    }
    
    func joinRoom(request: JoinRoomRequest, completion: @escaping (Result<GetRoomInfoResponse, Error>) -> Void) {
        let endpoint = MainEndpoint.joinRoom
        fetch(endpoint: endpoint, body: request, method: .post, completion: completion)
    }
    
    func passAdminStatus(request: PassAdminStatusRequest, completion: @escaping (VoidResult) -> Void) {
        let endpoint = MainEndpoint.passAdminStatus
        fetch(endpoint: endpoint, body: request, method: .put, completion: completion)
    }
    
    func deleteUserFromRoom(request: DeleteUserFromRoomRequest, completion: @escaping (VoidResult) -> Void) {
        let endpoint = MainEndpoint.deleteUserFromRoomRequest
        fetch(endpoint: endpoint, body: request, method: .delete, completion: completion)
    }
    
    func leaveRoom(completion: @escaping (VoidResult) -> Void) {
        let endpoint = MainEndpoint.leaveRoomRequest
        fetch(endpoint: endpoint, body: Empty(), method: .delete, completion: completion)
    }
    
    func addToTeam(request: AddUserToTeamRequest, completion: @escaping (VoidResult) -> Void) {
        let endpoint = MainEndpoint.addToTeamRequest
        fetch(endpoint: endpoint, body: request, method: .put, completion: completion)
    }
    
    func deleteTeam(request: DeleteRoomRequest, completion: @escaping (VoidResult) -> Void) {
        let endpoint = MainEndpoint.deleteTeam
        fetch(endpoint: endpoint, body: request, method: .delete, completion: completion)
    }
    
    func startGame(request: StartGameRequest, completion: @escaping (VoidResult) -> Void) {
        let endpoint = MainEndpoint.startGame
        fetch(endpoint: endpoint, body: request, method: .post, completion: completion)
    }
    
    func nextRound(request: NextRoundRequest, completion: @escaping (VoidResult) -> Void) {
        let endpoint = MainEndpoint.nextRound
        fetch(endpoint: endpoint, body: request, method: .post, completion: completion)
    }
    
    func deleteUser(completion: @escaping (VoidResult) -> Void) {
        let endpoint = MainEndpoint.deleteProfile
        fetch(endpoint: endpoint, body: Empty(), method: .delete, completion: completion)
    }
    
    func changeRoomStatus(request: ChangeRoomStateRequest, completion: @escaping (Result<ChangeRoomStateResponse, Error>) -> Void) {
        let endpoint = MainEndpoint.changeRoomStateRequest
        fetch(endpoint: endpoint, body: request, method: .post, completion: completion)
    }
    
    func fetch<T: Decodable, B: Codable>(endpoint: Endpoint, body: B, method: NetworkModel.Method, completion: @escaping (Result<T, Error>) -> Void) {
        var json: Data?
        if method != .get {
            json = try? JSONEncoder().encode(body)
        }
        guard let token = storage.authToken else {
            return
        }
        let header: HeaderModel = ["Auth": token]
   
        let request = Request(endpoint: endpoint, method: method, body: json, headers: header)

        networking.execute(request) { result in
            switch result {
            case .success(let result):
                guard let response = result.response as? HTTPURLResponse else {
                    return
                }

                switch response.statusCode {
                case 200...299:
                    guard let data = result.data,
                          let decodedData = try? JSONDecoder().decode(T.self, from: data)
                    else {
                        return
                    }

                    completion(.success(decodedData))

                default:
                    completion(.failure(NetworkModel.ErrorCode(code: response.statusCode)))
                    print(response)
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetch<B: Codable>(endpoint: Endpoint, body: B, method: NetworkModel.Method, completion: @escaping (VoidResult) -> Void) {
        var json: Data?
        if method != .get {
            json = try? JSONEncoder().encode(body)
        }
        guard let token = storage.authToken else {
            return
        }
        let header: HeaderModel = ["Auth": token]
   
        let request = Request(endpoint: endpoint, method: method, body: json, headers: header)

        networking.execute(request) { result in
            switch result {
            case .success(let result):
                guard let response = result.response as? HTTPURLResponse else {
                    return
                }

                switch response.statusCode {
                case 200...299:
                    completion(.success)
                default:
                    completion(.failure(NetworkModel.ErrorCode(code: response.statusCode)))
                    print(response)
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
