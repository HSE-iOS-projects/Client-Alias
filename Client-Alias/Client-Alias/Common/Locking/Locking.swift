public protocol Locking {
    func lock()
    func unlock()

    func withCritical<Result>(_ section: () throws -> Result) rethrows -> Result
}
