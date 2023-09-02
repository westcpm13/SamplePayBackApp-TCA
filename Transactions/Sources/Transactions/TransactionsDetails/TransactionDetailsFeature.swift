import ComposableArchitecture
import SwiftUI

public struct TransactionDetailsFeature: Reducer {
    
    public struct State: Equatable {
        var transactionModel: TransactionModel
    }
    
    public enum Action: Equatable {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}
