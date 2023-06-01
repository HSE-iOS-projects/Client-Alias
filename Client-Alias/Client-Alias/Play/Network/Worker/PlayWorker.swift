import Foundation

protocol PlayWorker {
    func nextRound(request: NextRoundRequest, completion: @escaping (VoidResult) -> Void)
    func endGame(request: EndGame, completion: @escaping (VoidResult) -> Void)
    func leaveRoom(completion: @escaping (VoidResult) -> Void)
}

final class PlayWorkerImpl: PlayWorker {
    let storage: SecureSettingsKeeper
    
    init(storage: SecureSettingsKeeper) {
        self.storage = storage
    }
    
    private let networking = Networking(baseURL: "http://127.0.0.1:8080")
    
    func nextRound(request: NextRoundRequest, completion: @escaping (VoidResult) -> Void) {
        let endpoint = MainEndpoint.nextRound
        fetch(endpoint: endpoint, body: request, method: .post, completion: completion)
    }
    
    func endGame(request: EndGame, completion: @escaping (VoidResult) -> Void) {
        let endpoint = PlayEndpoint.endGame
        fetch(endpoint: endpoint, body: request, method: .put, completion: completion)
    }
    
    func leaveRoom(completion: @escaping (VoidResult) -> Void) {
        let endpoint = MainEndpoint.leaveRoomRequest
        fetch(endpoint: endpoint, body: Empty(), method: .delete, completion: completion)
    }
    
    func fetch<B: Codable>(endpoint: Endpoint, body: B, method: NetworkModel.Method, completion: @escaping (VoidResult) -> Void) {
        var json: Data? = nil
        if method != .get {
            json = try? JSONEncoder().encode(body)
        }
            guard let token = storage.authToken else {
                return
            }
            let header: HeaderModel = ["Auth" : token]
   
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
