@testable import Validation
import XCTest

final class DeferredValueStoresTests: XCTestCase {
    private let subject = KeyedDeferredValueStore<String, Int>()
    var keyedWasCalled = false
    
    func test_getOrPut_SetsValue() async {
        _ = subject.getOrPut(Task { 1 }, forKey: "X")
        let dictionary = subject.deferred
        XCTAssertNotNil(dictionary["X"])
    }
    
    func test_getOrPut_RetrievesStoredValue_FromHashedValueStore() async {
        _ = try? await subject.getOrPut(Task { 44 }, forKey: "X").value
        _ = subject.getOrPut(
            Task {
                self.keyedWasCalled = true
                return 1
            },
            forKey: "X"
        )
        let value = try? await subject.deferred["X"]?.value
        await yield()
        XCTAssertEqual(44, value)
        XCTAssertFalse(keyedWasCalled)
    }
    
    func test_replaceValue_HashedValueStore() async {
        _ = try? await subject.getOrPut(Task { 44 }, forKey: "X").value
        _ = subject.replaceValue(
            Task {
                self.keyedWasCalled = true
                return 1
            },
            forKey: "X"
        )
        let value = try? await subject.deferred["X"]?.value
        await yield()
        XCTAssertEqual(1, value)
        XCTAssertTrue(keyedWasCalled)
    }
    
    func test_clear_RemovesValues() async throws {
        _ = subject.getOrPut(Task { 44 }, forKey: "X")
        
        subject.clear()
        
        let hash = try await subject.deferred["X"]?.value
        
        XCTAssertNil(hash)
    }
    
    func test_getOrPut_AutoClears_FailedTasks() async throws {
        do {
            _ = try await subject.getOrPut(Task { throw NSError() }, forKey: "X").value
            XCTFail(#function)
        } catch {
            XCTAssertNil(subject.deferred["X"])
        }
    }
    
    func test_replaceValue_AutoClears_FailedTasks() async throws {
        do {
            _ = try await subject.replaceValue(Task { throw NSError() }, forKey: "X").value
            XCTFail(#function)
        } catch {
            XCTAssertNil(subject.deferred["X"])
        }
    }
    
    func yield() async {
        await Task(priority: .low) {
            await Task.yield()
        }.value
    }
}
