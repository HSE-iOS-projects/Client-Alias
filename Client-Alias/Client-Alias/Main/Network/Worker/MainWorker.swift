import Foundation

protocol MainWorker {
    func createRoom(request: RoomRequest, completion: @escaping (Result<RoomResponse, Error>) -> Void)
    func gellAllRooms(completion: @escaping (Result<[AllRoomsResponse], Error>) -> Void)
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
    
    func gellAllRooms(completion: @escaping (Result<[AllRoomsResponse], Error>) -> Void) {
        let endpoint = MainEndpoint.getAllRooms
        fetch(endpoint: endpoint, body: Empty(), method: .get, completion: completion)
    }

    func fetch<T: Decodable, B: Codable>(endpoint: Endpoint, body: B, method: NetworkModel.Method, completion: @escaping (Result<T, Error>) -> Void) {
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
                        guard let data = result.data,
                              let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
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

}
