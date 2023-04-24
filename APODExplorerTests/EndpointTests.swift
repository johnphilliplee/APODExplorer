import XCTest
@testable import APODExplorer

final class EndpointTests: XCTestCase {
    func testEndpointURL() throws {
        let endpoint = Endpoint(
            scheme: .https,
            host: "api.example.com",
            path: "/sample",
            queryItems: [URLQueryItem(name: "sample_key", value: "sample_value")]
        )
        
        let url = try XCTUnwrap(endpoint.url)
        XCTAssertEqual("https://api.example.com/sample?sample_key=sample_value", url.absoluteString)
    }
}
