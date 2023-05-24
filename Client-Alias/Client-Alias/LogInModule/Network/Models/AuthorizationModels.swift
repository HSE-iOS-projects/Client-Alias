import Foundation

// MARK: - RegisterResponse

struct RegisterResponse: Codable {
    let email: String
    let id: UUID
    let password: String
}

// MARK: - Register

struct Register: Codable {
    let email: String
    let password: String
}

// MARK: - LoginResponse

struct LoginResponse: Codable {
    let email: String
    let id: UUID
    let password: String
}

// MARK: - Login

struct Login: Codable {
    let email: String
    let password: String
}
