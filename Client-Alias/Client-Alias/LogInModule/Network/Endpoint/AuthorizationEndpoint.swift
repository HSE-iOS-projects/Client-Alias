import Foundation

enum AuthorizationEndpoint: Endpoint {
    
    case register
    case login

    var compositPath: String {
        switch self {
        case .register:
            return "/auth/register"
        case .login:
            return "/auth/login"
        }
    }

    var headers: HeaderModel { [:] }
}
