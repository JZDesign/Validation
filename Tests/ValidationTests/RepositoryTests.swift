@testable import Validation
import XCTest

final class RepositoryTests: XCTestCase {

    func test_callsRemote_whenCacheIsExpired() async throws {
        let sut = makeSUT(nowProvider: { .now })

        sut.spy.stubResponse(with: .success([]))
        _ = try await sut.subject.getFeatures()
        
        XCTAssertEqual(sut.spy.invocations.count, 1)
    }
    
    func test_reusesTaskUntilCacheExpires() async throws {
        var date = Date.now
        
        let sut = makeSUT(nowProvider: { date })
        sut.spy.stubResponse(with: .success([]))
        _ = try await sut.subject.getFeatures()
        _ = try await sut.subject.getFeatures()
        _ = try await sut.subject.getFeatures()
        _ = try await sut.subject.getFeatures()
        _ = try await sut.subject.getFeatures()
        
        XCTAssertEqual(sut.spy.invocations.count, 1)

        date = .distantFuture

        sut.spy.stubResponse(at: 1, with: .success([]))

        _ = try await sut.subject.getFeatures()
        XCTAssertEqual(sut.spy.invocations.count, 2)
    }
    
    func test_resetsCacheOnFailure() async throws {
        let now = Date.now
        let sut = makeSUT(nowProvider: { now })
        await sut.rules.setCacheTime()
        
        let first = await sut.rules.lastCacheDate
        XCTAssertEqual(first, now)
                
        sut.spy.stubResponse(with: .failure(MockError()))
        
        _ = try? await sut.subject.getFeatures()
        let second = await sut.rules.lastCacheDate
        XCTAssertNotEqual(second, now)
    }
    
    func makeSUT(function: StaticString = #function, nowProvider: @escaping () -> Date) -> SystemUnderTest {
        let calendar = Calendar(identifier: .gregorian)
        let rules = CacheRules(calendar: calendar, nowProvider: nowProvider)
        
        let url = URL(string: "data:\(function)")!
        let spy = GetFeaturesCallSpy()
        
        let subject = NewFeatureRepository(url: url, getFeatures: spy.callAsFunction, refreshCacheRule: rules)
        return SystemUnderTest(
            calendar: calendar,
            rules: rules,
            spy: spy,
            subject: subject)
    }
    
    struct SystemUnderTest {
        let calendar: Calendar
        let rules: CacheRules
        let spy: GetFeaturesCallSpy
        let subject: NewFeatureRepository
    }
    
    struct MockError: Error { }
}
