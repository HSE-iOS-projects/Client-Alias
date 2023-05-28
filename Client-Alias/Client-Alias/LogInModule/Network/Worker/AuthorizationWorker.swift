import Foundation

protocol AuthorizationWorker {

    func register(email: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void)
    func login(email: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void)

}

final class AuthorizationWorkerImpl: AuthorizationWorker {
    
    private let networking = Networking(baseURL: "http://127.0.0.1:8080")

    func register(email: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        let endpoint = AuthorizationEndpoint.register
        let body = Register(nickname: email, password: password)
        fetch(endpoint: endpoint, body: body, completion: completion)
    }

    func login(email: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        let endpoint = AuthorizationEndpoint.login
        let body = Login(nickname: email, password: password)
        fetch(endpoint: endpoint, body: body, completion: completion)
    }

    func fetch<T: Decodable, B: Codable>(endpoint: Endpoint, body: B, completion: @escaping (Result<T, Error>) -> Void) {
            let json = try? JSONEncoder().encode(body)
        
            let request = Request(endpoint: endpoint, method: .post, body: json)

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
