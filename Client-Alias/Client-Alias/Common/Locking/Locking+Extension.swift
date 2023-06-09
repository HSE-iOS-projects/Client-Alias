import Foundation

extension NSLock : Locking {
    public func withCritical<Result>(_ section: () throws -> Result) rethrows -> Result {
        if !`try`() {
            lock()
        }

        defer {
            unlock()
        }

        return try section()
    }
}

extension NSRecursiveLock : Locking {
    public func withCritical<Result>(_ section: () throws -> Result) rethrows -> Result {
        if !`try`() {
            lock()
        }

        defer {
            unlock()
        }

        return try section()
    }
}

extension NSCondition : Locking {
    public func withCritical<Result>(_ section: () throws -> Result) rethrows -> Result {
        lock()

        defer {
            unlock()

            broadcast()
        }

        return try section()
    }
}
