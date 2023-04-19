import XCTest
@testable import APODExplorer

final class APODViewModelTests: XCTestCase {
    func testFetchAPODs() throws {
        let viewModel = APODViewModel(apodService: MockAPODService())
        let startDateComponents = DateComponents(calendar: Calendar(identifier: .gregorian), timeZone: TimeZone(identifier: "UTC"), year: 2022, month: 4, day: 1)
        let endDateComponents = DateComponents(calendar: Calendar(identifier: .gregorian), timeZone: TimeZone(identifier: "UTC"), year: 2022, month: 4, day: 10)

        let start = try XCTUnwrap(startDateComponents.date)
        let end = try XCTUnwrap(endDateComponents.date)

        let expectation = self.expectation(description: "Fetch Error")
        
        viewModel.fetchAPODS(start: start, end: end) { result in
            if case .failure = result {
                XCTFail("Expected Success")
            }
            
            XCTAssertEqual(viewModel.numberOfSections(), 1)
            XCTAssertEqual(viewModel.numberOfItemsInSection(0), 10)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3)
    }
    
    func testFetchAPODsWithError() throws {
        let viewModel = APODViewModel(apodService: MockAPODService(withError: true))
        let startDateComponents = DateComponents(calendar: Calendar(identifier: .gregorian), timeZone: TimeZone(identifier: "UTC"), year: 2022, month: 4, day: 1)
        let endDateComponents = DateComponents(calendar: Calendar(identifier: .gregorian), timeZone: TimeZone(identifier: "UTC"), year: 2022, month: 4, day: 10)
        
        let start = try XCTUnwrap(startDateComponents.date)
        let end = try XCTUnwrap(endDateComponents.date)
        
        let expectation = self.expectation(description: "Fetch Error")
        
        viewModel.fetchAPODS(start: start, end: end) { result in
            if case .success = result {
                XCTFail("Expected Error")
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3)
    }
}

class MockAPODService: APODService {
    let apods = [
        APOD(date: "2022-04-01", title: "title 1", url: "url 1", explanation: "explanation 1"),
        APOD(date: "2022-04-02", title: "title 2", url: "url 2", explanation: "explanation 2"),
        APOD(date: "2022-04-03", title: "title 3", url: "url 3", explanation: "explanation 3"),
        APOD(date: "2022-04-04", title: "title 4", url: "url 4", explanation: "explanation 4"),
        APOD(date: "2022-04-05", title: "title 5", url: "url 5", explanation: "explanation 5"),
        APOD(date: "2022-04-06", title: "title 6", url: "url 6", explanation: "explanation 6"),
        APOD(date: "2022-04-07", title: "title 7", url: "url 7", explanation: "explanation 7"),
        APOD(date: "2022-04-08", title: "title 8", url: "url 8", explanation: "explanation 8"),
        APOD(date: "2022-04-09", title: "title 9", url: "url 9", explanation: "explanation 9"),
        APOD(date: "2022-04-10", title: "title 10", url: "url 10", explanation: "explanation 10")
    ]
    
    enum MockAPODServiceError: Error {
        case mockError
    }
    
    init(withError: Bool = false) {
        self.withError = withError
    }
    
    let withError: Bool
    
    func fetchAPODs(start: Date, end: Date, completion: @escaping (Result<[APODExplorer.APOD], Error>) -> Void) {
        if withError {
            completion(.failure(MockAPODServiceError.mockError))
        } else {
            completion(.success(apods))
        }
    }
}
