import XCTest
import Transactions
import ComposableArchitecture
@testable import WorldOfPAYBACKApp

final class WorldOfPAYBACKAppTests: XCTestCase {
    func testInjectBaseUrlToTransactionsReducer() {
        let environment = AppEnvironment()
        let model = withDependencies {
            $0.transactionsConfiguration = TransactionsConfiguration(
                baseUrl: URL(string: environment.baseURL)
            )
        } operation: {
            TransactionsFeature()
        }        
        let dic = ProcessInfo.processInfo.environment
        if let forceProduction = dic["isProduction"] , forceProduction == "true" {
            XCTAssertEqual(
                model.transactionsConfiguration.baseUrl?.absoluteString, "https://api.payback.com/"
            )
        } else {
            XCTAssertEqual(
                model.transactionsConfiguration.baseUrl?.absoluteString, "https://api-test.payback.com/"
            )
        }
    }
}
