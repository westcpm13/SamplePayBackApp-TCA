import XCTest
import Combine
@testable import Transactions

@MainActor
final class NetworkMonitorTests: XCTestCase {
    func testPathNetworkManagerStartAndCancelBehaviour() throws {
        let pathMonitorMock = NetworkPathMonitorMock()
        let sut = NetworkMonitor(pathMonitor: pathMonitorMock)
        // Durning create object the method start is called
        XCTAssertTrue(pathMonitorMock.startMethodCalled)
        XCTAssertFalse(pathMonitorMock.cancelMethodCalled)
        
        sut.cancelMonitoring()
        XCTAssertTrue(pathMonitorMock.cancelMethodCalled)
    }
}
