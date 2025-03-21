@testable import Validation
import XCTest

final class ViewModelTests: XCTestCase {
    @MainActor
    func test_getAsync_updatesViewState() async throws {
        let viewModel = NewFeaturesViewModel(featureRetriever: MockFeatureRetrieving())
        XCTAssertTrue(viewModel.features.isEmpty)
        
        var loadingStates: [Bool] = []
        let job = viewModel.$isLoading.sink { value in
            loadingStates.append(value)
        }
        try await viewModel.getFeaturesAsync()
        
        XCTAssertEqual(loadingStates, [false, true, false])
        XCTAssertFalse(viewModel.features.isEmpty)
    }
}
