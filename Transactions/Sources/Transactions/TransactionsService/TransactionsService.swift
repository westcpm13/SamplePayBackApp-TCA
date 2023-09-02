import ComposableArchitecture
import Combine
import Foundation

public struct TransactionsBox: Sendable, Identifiable, Equatable {
    public static func == (lhs: TransactionsBox, rhs: TransactionsBox) -> Bool {
        lhs.id == rhs.id
    }
    public let id: UUID
    public var transactionsApi: IdentifiedArrayOf<TransactionModel>
    var sortedTransactions: IdentifiedArrayOf<TransactionModel>
    var categoryGroupedTransacions: IdentifiedArrayOf<GroupedTransactionModel>
}

struct TransactionsService {
    var loadTransactions: @Sendable (
        _ transactionsParser: TransactionsParsing,
        _ transactionDataServices: TransactionDataServicing,
        _ transactionDataServicesModel: TransactionDataServicesModel,
        _ transactionsGroupedBuilder: TransactionsGroupedBuilding
    ) async throws -> TransactionsBox
}

extension DependencyValues {
    var transactionsService: TransactionsService {
        get { self[TransactionsService.self] }
        set { self[TransactionsService.self] = newValue }
    }
}

extension TransactionsService: DependencyKey {
    static let liveValue = transactionsService
    static let testValue = transactionsService
    
    static let transactionsService = Self(
        loadTransactions: {
            transactionsParser,
            transactionDataServices,
            transactionDataServicesModel,
            transactionsGroupedBuilder in
            do {
                let data: Data = try await transactionDataServices.loadTransactionsData(with: transactionDataServicesModel)
                let transactionList = transactionsParser.parseData(data)
                let categoryGroupedTransacions = transactionsGroupedBuilder.groupedTransactions(transactionList)
                
                let sortedTransactions = transactionList.sorted { (transaction1, transaction2) -> Bool in
                    if let date1 = transaction1.transactionDetail?.bookingDate,
                       let date2 = transaction2.transactionDetail?.bookingDate {
                        return date1 > date2
                    }
                    return false
                }
                return TransactionsBox(
                    id: transactionDataServicesModel.uuid(),
                    transactionsApi: transactionList,
                    sortedTransactions: IdentifiedArrayOf(uniqueElements: sortedTransactions),
                    categoryGroupedTransacions: categoryGroupedTransacions
                )
                
            } catch {
                //Handle it in future
                print("TransactionsService: ERROR: proble loadTransactionsData")
            }
            return TransactionsBox(
                id: transactionDataServicesModel.uuid(),
                transactionsApi: [],
                sortedTransactions: [],
                categoryGroupedTransacions: []
            )
        }
    )
}

