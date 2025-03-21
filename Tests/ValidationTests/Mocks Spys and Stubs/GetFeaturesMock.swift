import Foundation
import Validation

final class GetFeaturesCallSpy: @unchecked Sendable {
    private(set) var invocations = [URL]()
    private(set) var responses = [Int: Result<[NewFeature], Error>]()
    
    func stubResponse(at index: Int = 0, with result: Result<[NewFeature], Error>) {
        responses[index] = result
    }
    
    @Sendable
    func callAsFunction(_ url: URL) async throws -> [NewFeature] {
        try await Task { @SpyActor in
            invocations.append(url)
            switch responses[invocations.count - 1]! {
            case .success(let value): return value
            case .failure(let error): throw error
            }
        }.value
    }
}

@globalActor actor SpyActor {
    static let shared = SpyActor()
}
