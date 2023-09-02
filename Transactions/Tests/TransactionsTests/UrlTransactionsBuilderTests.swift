import XCTest
import Combine
import ComposableArchitecture
import Foundation
@testable import Transactions

@MainActor
final class UrlBuilderTransactionsTests: XCTestCase {
    func testUrlBuilderTransactions() throws {
        let sut = withDependencies {
            $0.transactionsConfiguration = TransactionsConfiguration(
                baseUrl: URL(string: "https://sample.url.com/"),
                isDemoUser: false
            )
          } operation: {
              UrlTransactionsBuilder()
          }
        XCTAssertEqual(sut.getUrl(for: .transactions)?.absoluteString, "https://sample.url.com/transactions")
    }
}
