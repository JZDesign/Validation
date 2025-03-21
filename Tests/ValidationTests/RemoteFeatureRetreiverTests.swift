@testable import Validation
import XCTest

final class RemoteFeatureRetreiverTests: XCTestCase {
    func test_hitsNetwork() async throws {
        let url = URL(string: "data:123")!
        URLProtocolStub.stub(
            url: url,
            data: try Data(contentsOf: makeFileURL(named: "Sample.json", file: #file, inSiblingDirectory: "JSON")),
            response: .init(),
            error: nil
        )
        URLProtocolStub.startInterceptingRequests()
        
        let subject = RemoteFeatureRetriever()
        let result = try await subject.getFeatures(from: url)
        
        let request = URLProtocolStub.invocations.last!
        
        XCTAssertEqual(request.url, url)
        URLProtocolStub.stopInterceptingRequests()
    }
}
