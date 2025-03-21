@testable import Validation
import XCTest

final class StringsTests: XCTestCase {
    func test_valuesAreSet() throws {
        throw XCTSkip("This requires xcode and our I need to configure that on the CI")

        let allStrings: [AutoLocalizing] = Strings.FeatureList.allCases + Strings.GatherFeedbackSection.allCases + Strings.FeatureStatus.allCases
        
        allStrings.forEach { string in
            XCTAssertNotEqual(String.LocalizationValue(string()), string.rawValue)
            XCTAssertNotEqual(string(), "")
        }
    }
}
