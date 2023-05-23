protocol SecureSettingsKeeper {

    var authToken: String? { get set }

    func clear()

}

final class SecureSettingsKeeperImpl: SecureSettingsKeeper {

    @Token("authToken")
    var authToken: String?

    func clear() {
        authToken = nil
    }

}
