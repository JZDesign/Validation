#if targetEnvironment(simulator)
import SwiftUI
import XCTest
@testable import Validation

@MainActor
/// These tests ensure that the view renders (mostly) appropriately. In my attempt to snapshot test this, I learned that SwiftUI's Material and shadow effects
/// Don't play nicely with the UIGraphicsImageRenderer, nor did I find success with SwiftUI's ImageRenderer (I got an error image)
/// Because of that, I injected a different shape style that approximates the layout but the shadow is wrong
final class ReviewUpcomingFeaturesScreenSnapshotTests: XCTestCase {
    func test_contactUs_isHidden() async throws {
        let viewModel = NewFeaturesViewModel(
            featureRetriever: MockFeatureRetrieving()
        )
        try await viewModel.getFeaturesAsync()
        let view = UIHostingController(
            rootView: NavigationView(content: {
                ReviewUpcomingFeaturesScreen(
                    viewModel: viewModel,
                    feedbackHandler: MockFeedbackHandling(),
                    rowBackground: Color.gray.opacity(0.2)
                )
            })
        )
        
        assert(snapshot: view.snapshot(for: .iPhone8(style: .light)), named: "\(#function)-light")
        assert(snapshot: view.snapshot(for: .iPhone8(style: .dark)), named: "\(#function)-dark")
    }
    
    func test_contactUs_isDisplayed() async throws {
        let viewModel = NewFeaturesViewModel(
            featureRetriever: MockFeatureRetrieving()
        )
        try await viewModel.getFeaturesAsync()
        let view = UIHostingController(
            rootView: NavigationView(content: {
                ReviewUpcomingFeaturesScreen(
                    viewModel: viewModel,
                    feedbackHandler: MockFeedbackHandling(),
                    emailAddress: "TheNerd@JacobZivanDesign.com",
                    rowBackground: Color.gray.opacity(0.2)
                )
            })
        )
        
        assert(snapshot: view.snapshot(for: .iPhone8(style: .light)), named: "\(#function)-light")
        assert(snapshot: view.snapshot(for: .iPhone8(style: .dark)), named: "\(#function)-dark")
    }
    
    func test_loadingState() async throws {
        let viewModel = NewFeaturesViewModel(
            featureRetriever: MockFeatureRetrieving()
        )
        let view = UIHostingController(
            rootView: NavigationView(content: {
                ReviewUpcomingFeaturesScreen(
                    viewModel: viewModel,
                    feedbackHandler: MockFeedbackHandling(),
                    rowBackground: Color.gray.opacity(0.2)
                )
            })
        )
        
        assert(snapshot: view.snapshot(for: .iPhone8(style: .light)), named: "\(#function)-light")
        assert(snapshot: view.snapshot(for: .iPhone8(style: .dark)), named: "\(#function)-dark")
    }
}

#endif
