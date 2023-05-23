import Foundation

extension SecureStorage {

    func addToken(_ token: String, for account: String) {
        var query: [CFString: Any] = [:]
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrAccount] = account
        query[kSecValueData] = token.data(using: .utf8)

        do {
            try addItem(query: query)
        } catch {
            return
        }
    }

    func updateToken(_ token: String, for account: String) {
        guard let _ = getToken(for: account) else {
            addToken(token, for: account)
            return
        }

        var query: [CFString: Any] = [:]
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrAccount] = account

        var attributesToUpdate: [CFString: Any] = [:]
        attributesToUpdate[kSecValueData] = token.data(using: .utf8)

        do {
            try updateItem(query: query, attributesToUpdate: attributesToUpdate)
        } catch {
            return
        }
    }

    func getToken(for account: String) -> String? {
        var query: [CFString: Any] = [:]
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrAccount] = account

        var result: [CFString: Any]?

        do {
            result = try findItem(query: query)
        } catch {
            return nil
        }

        if let data = result?[kSecValueData] as? Data {
            return String(data: data, encoding: .utf8)
        } else {
            return nil
        }
    }

    func deleteToken(for account: String) {
        var query: [CFString: Any] = [:]
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrAccount] = account

        do {
            try deleteItem(query: query)
        } catch {
            return
        }
    }
    
}
