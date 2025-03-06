import Foundation
@testable import Case

final class MockURLSession: URLSessionProtocol {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    
    func data(
        from url: URL,
        delegate: URLSessionTaskDelegate?
    ) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        
        return (
            mockData ?? Data(),
            mockResponse ?? HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
        )
    }
} 