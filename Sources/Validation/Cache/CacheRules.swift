import Foundation

public actor CacheRules {
    let timeoutInMinutes: UInt
    let calendar: Calendar
    let nowProvider: () -> Date
    
    var lastCacheDate: Date = .distantPast
    
    public init(
        timeoutInMinutes: UInt = 60,
        calendar: Calendar = .current,
        nowProvider: @escaping () -> Date = { .now }
    ) {
        self.timeoutInMinutes = timeoutInMinutes
        self.calendar = calendar
        self.nowProvider = nowProvider
    }
    
    public var isCacheExpired: Bool {
        (calendar.date(byAdding: .minute, value: Int(timeoutInMinutes), to: lastCacheDate) ?? .distantPast) < nowProvider()
    }
    
    public func clear() {
        lastCacheDate = .distantPast
    }
    
    public func setCacheTime() {
        lastCacheDate = nowProvider()
    }
}
