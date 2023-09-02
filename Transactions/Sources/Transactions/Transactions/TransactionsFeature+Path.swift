import SwiftUI
import ComposableArchitecture
import Combine

public extension TransactionsFeature {
    public struct Path: Reducer {
        public init() {
            
        }
        public enum State: Equatable {
            case transactionsScreen(TransactionsFeature.State)
            case transactionDetailsScreen(TransactionDetailsFeature.State)
        }
        
        public enum Action: Equatable {
            case transactionsScreen(TransactionsFeature.Action)
            case transactionDetailsScreen(TransactionDetailsFeature.Action)
        }
        
        public var body: some ReducerOf<Self> {
            Scope(
                state: /State.transactionsScreen,
                action: /Action.transactionsScreen
            ) {
                TransactionsFeature()
            }
            Scope(
                state: /State.transactionDetailsScreen,
                action: /Action.transactionDetailsScreen
            ) {
                TransactionDetailsFeature()
            }
        }
    }
}
