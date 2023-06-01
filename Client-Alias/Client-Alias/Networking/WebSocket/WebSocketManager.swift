import Starscream
import Foundation

protocol WebSocketObserver: AnyObject {
    
    func receiveStartGame()
    func receiveWords(words: [String])
    func receiveWaiting()
    func receiveWaitingForResults()
    func receiveResults(result: String)
    
}

protocol WebSocketManager: Observable where Observer == WebSocketObserver {
    
    func connect()
    
}

final class WebSocketManagerImpl: WebSocketManager {
        
    private enum Endpoint {

        static let url = URL(string: "ws://127.0.0.1:8080/socket/game")!
        
    }
    
    static let shared = WebSocketManagerImpl()
    
    private var webSocket: WebSocket?
    private var storage = SecureSettingsKeeperImpl()
    private var isConnected: Bool = false
    
    private init() {}
    
    var observers = ObserversCollection<WebSocketObserver>()
    
    func connect() {
        var request = URLRequest(url: Endpoint.url)
        request.setValue(storage.authToken, forHTTPHeaderField: "Auth")
        request.timeoutInterval = 5
        webSocket = WebSocket(request: request)
        webSocket?.delegate = self
        webSocket?.connect()
    }
    
}

extension WebSocketManagerImpl: WebSocketDelegate {
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
            
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
            
        case .text(let string):
            print("Received text: \(string)")
            
            if string.count > 20 {
                let words = String(string.dropFirst(6))
                guard let data = Data(base64Encoded: words) else { return }
                guard let val = try? JSONDecoder().decode([String].self, from: data) else { return }
                print(val)
                observers.notify(with: { $0.receiveWords(words: val) })
            }
            else {
                switch string {
                case "start":
                    observers.notify(with: { $0.receiveStartGame() })
                    
                case "waitForResults":
                    observers.notify(with: { $0.receiveWaitingForResults() })
                    
                case "You win", "You lose":
                    observers.notify(with: { $0.receiveResults(result: string) })
                    
                case "wait":
                    observers.notify(with: { $0.receiveWaiting()})
                    
                default:
                    break
                }
            }

        case .binary(let data):
            print("Received data: \(data.count)")
            
        case .ping(_):
            break
            
        case .pong(_):
            break
            
        case .viabilityChanged(_):
            break
            
        case .reconnectSuggested(_):
            break
            
        case .cancelled:
            isConnected = false
            
        case .error(let error):
            isConnected = false
            print(error)
        }
    }
    
}
