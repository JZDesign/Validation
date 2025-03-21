import Foundation

public protocol FeatureRetrieving {
    func getFeatures() async throws -> [NewFeature]
}
