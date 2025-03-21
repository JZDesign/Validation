import Combine
import SwiftUI

@MainActor
public final class NewFeaturesViewModel: ObservableObject, Sendable {
    let featureRetriever: FeatureRetrieving

    @Published var features: [NewFeature] = []
    @Published var isLoading = false

    public init(
        featureRetriever: FeatureRetrieving
    ) {
        self.featureRetriever = featureRetriever
    }

    public func getFeaturesAsync() async throws {
        isLoading = true
        do {
            features = try await featureRetriever.getFeatures()
            isLoading = false
        } catch {
            isLoading = false
            throw error
        }
    }
}
