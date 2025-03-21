import Foundation
import Validation

class MockFeatureRetrieving: FeatureRetrieving {
    var shouldThrowError = false
    var invocationCount = 0

    func getFeatures() async throws -> [NewFeature] {
        invocationCount += 1
        try await Task.sleep(nanoseconds: 10)
        if shouldThrowError {
            throw MockError()
        }
        return try decodeContentsOfFile(named: "Sample.json", file: #file, inSiblingDirectory: "JSON")
    }
    
    struct MockError: Error { }
}
