import ComposableArchitecture
import Transactions

struct AppReducer: Reducer {
    
    struct State: Equatable {
        var path = StackState<TransactionsFeature.Path.State>()
    }
    
    enum Action: Equatable {
        case path(StackAction<TransactionsFeature.Path.State, TransactionsFeature.Path.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
        .forEach(\.path, action: /Action.path) {
            TransactionsFeature.Path()
        }
    }
}
