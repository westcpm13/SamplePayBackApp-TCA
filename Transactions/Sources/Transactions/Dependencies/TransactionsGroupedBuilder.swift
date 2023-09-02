import Combine
import Foundation
import ComposableArchitecture

struct GroupedTransactionModel: Sendable, Identifiable, Equatable {
    public static func == (lhs: GroupedTransactionModel, rhs: GroupedTransactionModel) -> Bool {
        lhs.id == rhs.id
    }
    let id: UUID
    let category: Int
    let sumTransactions: Decimal
    let transactions: IdentifiedArrayOf<TransactionModel>
    
    var categoryString: String {
        "\(category)"
    }
    var sumTransactionsString: String {
        ["\(sumTransactions)", transactions.first?.transactionDetail?.amount?.currency ?? ""].joined(separator: " ")
    }
}

protocol TransactionsGroupedBuilding {
    @Sendable
    func groupedTransactions(
        _ transactions: IdentifiedArrayOf<TransactionModel>
    ) -> IdentifiedArrayOf<GroupedTransactionModel>
}

struct TransactionsGroupedBuilder: TransactionsGroupedBuilding {
    @Dependency(\.uuid) private var uuid
    
    func groupedTransactions(
        _ transactions: IdentifiedArrayOf<TransactionModel>
    ) -> IdentifiedArrayOf<GroupedTransactionModel> {
        
        var groupedTransactionsDictionary: [Int: [TransactionModel]] = [:]
        
        for transaction in transactions {
            if let category = transaction.category {
                if groupedTransactionsDictionary[category] == nil {
                    groupedTransactionsDictionary[category] = []
                }
                groupedTransactionsDictionary[category]?.append(transaction)
            }
        }
        var groupedTransactions: IdentifiedArrayOf<GroupedTransactionModel> = []
        
        for (category, transactions) in groupedTransactionsDictionary {
            let groupedTransactionModel = GroupedTransactionModel(
                id: uuid(),
                category: category,
                sumTransactions: transactions.reduce(0.0, { result, transaction in
                    if let transactionAmount = transaction.transactionDetail?.amount?.value {
                        return result + transactionAmount
                    }
                    return result
                }),
                transactions: IdentifiedArrayOf(uniqueElements: transactions)
            )
            groupedTransactions.append(groupedTransactionModel)
        }
        let sortedGroupedTransactions = groupedTransactions.sorted {
            $0.category < $1.category
        }
        return IdentifiedArrayOf(uniqueElements: sortedGroupedTransactions)
    }
}

extension DependencyValues {
    var transactionsGroupedBuilder: TransactionsGroupedBuilder {
        get { self[TransactionsGroupedBuilderKey.self] }
        set { self[TransactionsGroupedBuilderKey.self] = newValue }
    }
    
    private enum TransactionsGroupedBuilderKey: DependencyKey {
        static let liveValue = TransactionsGroupedBuilder()
        static let testValue = TransactionsGroupedBuilder()
    }
}

