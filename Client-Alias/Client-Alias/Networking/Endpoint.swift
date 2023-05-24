import Foundation

protocol Endpoint {
    var compositPath: String { get }
    var headers: HeaderModel { get }
}
