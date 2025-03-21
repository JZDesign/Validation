import Foundation

final public class NewFeatureRepository: Sendable, FeatureRetrieving {
    let url: URL
    let getFeatures: @Sendable (URL) async throws -> [NewFeature]
    let taskMutex: KeyedDeferredValueStore<URL, [NewFeature]>
    let refreshCacheRule: CacheRules
    
    public static let taskMutex = KeyedDeferredValueStore<URL, [NewFeature]>()
    public static let refreshCacheRule = CacheRules()
    
    public init(
        url: URL,
        getFeatures: @escaping @Sendable (URL) async throws -> [NewFeature],
        taskMutex: KeyedDeferredValueStore<URL, [NewFeature]> = NewFeatureRepository.taskMutex,
        refreshCacheRule: CacheRules = NewFeatureRepository.refreshCacheRule
    ) {
        self.url = url
        self.getFeatures = getFeatures
        self.taskMutex = taskMutex
        self.refreshCacheRule = refreshCacheRule
    }

    public func getFeatures() async throws -> [NewFeature] {
        if await refreshCacheRule.isCacheExpired {
            taskMutex.clear()
            await refreshCacheRule.clear()
        }

        let task = taskMutex.getOrPut(
            Task { [weak self] in
                guard let self else { return [] }

                let value = try await getFeatures(url)
                await refreshCacheRule.setCacheTime()
                return value
            },
            forKey: url
        )
        switch await task.result {
        case .success(let result):
            return result
        case .failure(let error):
            taskMutex.clear()
            await refreshCacheRule.clear()
            throw error
        }
    }
    
}
