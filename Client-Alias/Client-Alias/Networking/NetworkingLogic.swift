import Foundation

protocol NetworkingLogic {
    
    typealias NetworkResult = Result<NetworkModel.Result, Error>
    
    func execute(_ request: Request, completion: @escaping (NetworkResult) -> Void)
}
