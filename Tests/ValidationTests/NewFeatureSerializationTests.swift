import XCTest
@testable import Validation

final class NewFeatureSerializationTests: XCTestCase {
    func test_feturesSerialize() throws {
        // decodes fine
        let features: [NewFeature] = try decodeContentsOfFile(named: "Sample.json", file: #file, inSiblingDirectory: "JSON")
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        
        // encodes id as a flat string not a nested object
        let data = try encoder.encode(features)
        
        let string: String = try contentsOfFile(named: "Sample.json", file: #file, inSiblingDirectory: "JSON").normalized()

        let result = String(data: data, encoding: .utf8)?.normalized()
        
        XCTAssertEqual(result, string)
    }
}

extension String {
    // Remove unwanted artifacts from encoding and decoding
    func normalized() -> String {
        replacingOccurrences(of: "  ", with: "")
        .replacingOccurrences(of: "\n", with: "")
        .replacingOccurrences(of: ": ", with: ":")
        .replacingOccurrences(of: "\\/", with: "/")
    }
}

