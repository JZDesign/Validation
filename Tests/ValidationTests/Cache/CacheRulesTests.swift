@testable import Validation
import XCTest

final class CacheRulesTests: XCTestCase {
    func test() async {
        let date = Date.distantPast
        let calendar = Calendar(identifier: .gregorian)
        let testCases = [
            (calendar.date(byAdding: .init(minute: 0, second: 1), to: date), false, #line as UInt),
            (calendar.date(byAdding: .init(minute: 59, second: 59), to: date), false, #line),
            (calendar.date(byAdding: .init(minute: 60, second: 0), to: date), false, #line),
            (calendar.date(byAdding: .init(minute: 60, second: 1), to: date), true, #line)
        ]
        
        for (setDate, expectedResult, line) in testCases {
            let rules = CacheRules(calendar: calendar) {
                setDate!
            }

            let maybeExpired = await rules.isCacheExpired

            await rules.setCacheTime()
            
            let notExpired = await rules.isCacheExpired

            await rules.clear()
            
            let lastCacheDate = await rules.lastCacheDate
            
            XCTAssertEqual(maybeExpired, expectedResult, line: line)
            XCTAssertFalse(notExpired, line: line)
            XCTAssertEqual(lastCacheDate, .distantPast)
        }
    }
}
