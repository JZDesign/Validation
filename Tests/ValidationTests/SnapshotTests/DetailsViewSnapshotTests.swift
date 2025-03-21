#if targetEnvironment(simulator)
import SwiftUI
import XCTest
@testable import Validation

final class DetailsViewSnapshotTests: XCTestCase {
    func test_markdownSupports_Bold_Italics_and_Links_but_DOES_NOT_SUPPORT_IMAGES() throws {
        let feature: NewFeature = try decodeContentsOfFile(named: "markdownExample.json", file: #file, inSiblingDirectory: "JSON")
        let view = UIHostingController(rootView: FeatureDetailView(feature: feature, positiveColor: .green, negativeColor: .red, feedbackHandler: { _ in
        }))
        
        assert(snapshot: view.snapshot(for: .iPhone8(style: .light)), named: "markdown-light")
        assert(snapshot: view.snapshot(for: .iPhone8(style: .dark)), named: "markdown-dark")
    }
    
    func test_canModifyColors() throws {
        let feature: NewFeature = try decodeContentsOfFile(named: "markdownExample.json", file: #file, inSiblingDirectory: "JSON")
        let view = UIHostingController(rootView: FeatureDetailView(feature: feature, positiveColor: .blue, negativeColor: .purple, feedbackHandler: { _ in
        })
            .tint(.yellow)
        )

        assert(snapshot: view.snapshot(for: .iPhone8(style: .light)), named: "modifiedColors-light")
        assert(snapshot: view.snapshot(for: .iPhone8(style: .dark)), named: "modifiedColors-dark") }
}
#endif
