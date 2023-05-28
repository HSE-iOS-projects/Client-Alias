import Foundation

enum NetworkModel {
    
    enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
        case options = "OPTIONS"
    }
    
    struct Result {
        var data: Data?
        var response: URLResponse?
    }
    
    
    struct ErrorCode: Error {
        let code: Int
        
    }

    struct Request {
        var method: Method
        var body: Data?
        var endpoint: Endpoint
        var parameters: RequestParameters?
        var headers: HeaderModel?
        
        init(
            endpoint: Endpoint,
            method: Method = .get,
            parameters: RequestParameters? = nil,
            body: Data? = nil,
            headers: HeaderModel = [:]
        ) {
            self.method = method
            self.body = body
            self.endpoint = endpoint
            self.parameters = parameters
            self.headers = headers
        }
    }
}


