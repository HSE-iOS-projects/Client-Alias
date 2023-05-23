@propertyWrapper
public struct Token {
    private let key: String
    private let storage = SecureStorage()

    public init(_ key: String) {
        self.key = key
    }
    
    public var wrappedValue: String? {
        get { storage.getToken(for: key) }

        set {
            if let newValue {
                storage.updateToken(newValue, for: key)
            } else {
                storage.deleteToken(for: key)
            }
        }
    }
}
