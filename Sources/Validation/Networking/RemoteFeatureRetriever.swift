import Foundation

struct RemoteFeatureRetriever: Sendable {
    @Sendable
    func getFeatures(from url: URL) async throws -> [NewFeature] {
        let request = URLRequest(url: url)
        // TODO: Use another session that waits for connectivity
        let result = try await URLSession.shared.data(for: request)
        // TODO: throw on non 200 level errors
        return try JSONDecoder().decode([NewFeature].self, from: result.0)
    }
}
