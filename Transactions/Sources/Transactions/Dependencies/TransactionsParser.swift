import Combine
import Foundation
import ComposableArchitecture

protocol TransactionsParsing {
    @Sendable
    func parseData(_ data: Data) -> IdentifiedArrayOf<TransactionModel>
}

struct TransactionsParser: TransactionsParsing {
    @Dependency(\.transacionDateFormatter) private var transacionDateFormatter
    
    func parseData(_ data: Data) -> IdentifiedArrayOf<TransactionModel> {
        let decoder = JSONDecoder()
        do {
            let model = try decoder.decode(PBTransactionsModel.self, from: data)
            var transactionsList: IdentifiedArrayOf<TransactionModel> = []
            model.items.forEach {
                var transaction = $0
                let bookingString = $0.transactionDetail?.bookingString
                if let bookingDate = transacionDateFormatter.format(
                    bookingString,
                    format: .transactions,
                    timeZone: TimeZone(identifier: "UTC")
                ) {
                    let bookingFormatted = transacionDateFormatter.getLocalizedDate(
                        bookingDate,
                        format: .transactions,
                        locale: Locale.current
                    )
                    transaction.transactionDetail?.bookingFormatted = bookingFormatted
                    transaction.transactionDetail?.bookingDate = bookingDate
                }
                transactionsList.append(transaction)
            }
            return transactionsList
            
        } catch {
            print("TransactionsParser: ERROR Parse data")
        }
        return []
    }
}

extension DependencyValues {
    var transactionsParser: TransactionsParser {
        get { self[TransactionsParserKey.self] }
        set { self[TransactionsParserKey.self] = newValue }
    }
    
    private enum TransactionsParserKey: DependencyKey {
        static let liveValue = TransactionsParser()
        static let testValue = TransactionsParser()
    }
}

