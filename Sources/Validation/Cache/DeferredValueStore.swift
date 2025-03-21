import Foundation

public typealias AnyTask<T> = Task<T, Error>

/// Holds onto ``Task`` objects by key, autoclearing on failure
public final class KeyedDeferredValueStore<H: Hashable, T>: @unchecked Sendable {
    private let lock: NSLock
    var deferred: [H: AnyTask<T>] = [:]

    /// Sets the task in the cache if one is not found
    /// - Parameters:
    ///   - task: The function that should execute if one is not found
    ///   - key: The key to look up the result by
    /// - Returns: The stored task
    public func getOrPut(_ task: @escaping @autoclosure () -> AnyTask<T>, forKey key: H) -> AnyTask<T> {
        lock.withLock {
            guard let result = self.deferred[key] else {
                let wrapped: AnyTask<T> = self.forgettingFailure(task, forKey: key)
                self.deferred[key] = wrapped
                return wrapped
            }
            return result
        }
    }

    /// Replaces a task in the store
    /// - Parameter task: The new function to store
    /// - Parameter key: The key to look up the result by
    /// - Returns: The stored task
    public func replaceValue(_ task: @escaping @autoclosure () -> AnyTask<T>, forKey key: H) -> AnyTask<T> {
        lock.withLock {
            let result = self.forgettingFailure(task, forKey: key)
            self.deferred[key] = result
            return result
        }
    }

    public func clear() {
        lock.withLock { self.deferred = [:] }
    }

    private func forgettingFailure(_ task: @escaping () -> AnyTask<T>, forKey key: H) -> AnyTask<T> {
        Task {
            do {
                return try await task().value
            } catch {
                _ = self.lock.withLock { self.deferred.removeValue(forKey: key) }
                throw error
            }
        }
    }

    public init(lock: NSLock = .init()) {
        self.lock = lock
    }
}
