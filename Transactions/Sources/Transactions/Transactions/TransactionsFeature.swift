import SwiftUI
import ComposableArchitecture
import Reachability
import Combine

enum Filter: LocalizedStringKey, CaseIterable, Hashable {
    case sortedTransactions = "Transactions"
    case filterTransactions = "Filtered transacions"
}

public struct TransactionsFeature: Reducer {
    ///for unit tests
    public var transactionsConfiguration: TransactionsConfiguration {
        transactionDataServicesModel.transactionsConfiguration
    }
    @Dependency(\.transactionDataServicesModel) private var transactionDataServicesModel
    @Dependency(\.transactionsService) private var transactionsService
    @Dependency(\.transactionDataServices) private var transactionDataServices
    @Dependency(\.transactionsGroupedBuilder) private var transactionsGroupedBuilder
    @Dependency(\.transactionsParser) private var transactionsParser
    @Dependency(\.continuousClock) private var clock

    private enum CancelID {
        case loadTransactionsRequest
    }

    public init() {}
    
    public struct State: Equatable {
        public init() {}
        @PresentationState var alert: AlertState<Action.Alert>?
        @BindingState var filter: Filter = .sortedTransactions
        var path = StackState<Path.State>()
        var isProgressBarShowed = true
        var isTransactionRequestRunning = false
   
        var transactionsApi: IdentifiedArrayOf<TransactionModel> = []
        var sortedTransactions: IdentifiedArrayOf<TransactionModel> = []
        var categoryGroupedTransacions: IdentifiedArrayOf<GroupedTransactionModel> = []
        var transactions: IdentifiedArrayOf<TransactionModel> = []
    }
    
    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case path(StackAction<Path.State, Path.Action>)
        case showNetworkAlert
        case loadTransactions(fromPullToRefresh: Bool)
        case loadTransactionsResponse(TaskResult<TransactionsBox>)

        case alert(PresentationAction<Action.Alert>)
        public enum Alert: Equatable {
            case refreshTransactionsButtonTapped
        }
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .showNetworkAlert:
                state.alert = .showNetworkAlert()
                return .none
            case .alert(.presented(.refreshTransactionsButtonTapped)):
                state.alert = nil
                return .send(.loadTransactions(fromPullToRefresh: false))
            case .alert(.dismiss):
                state.alert = nil
                return .none
            case let .loadTransactions(fromPullToRefresh):
                if state.isTransactionRequestRunning {
                    state.isTransactionRequestRunning = false
                    state.isProgressBarShowed = false
                    return .cancel(id: CancelID.loadTransactionsRequest)
                }
                state.isTransactionRequestRunning = true
                
                if !fromPullToRefresh {
                    state.isProgressBarShowed = true
                }
                return .run { send in
                    try await self.clock.sleep(for: .seconds(2))
                    //for test random error
                    let randomNumber = Double.random(in: 0.0...1.0)
                    if randomNumber < 1.0/3.0 {
                        await send(.loadTransactionsResponse(TaskResult.failure(NSError())))
                    } else {
                        await send(
                            .loadTransactionsResponse(
                                TaskResult {
                                    try await self.transactionsService.loadTransactions(
                                        transactionsParser,
                                        transactionDataServices,
                                        transactionDataServicesModel,
                                        transactionsGroupedBuilder
                                    )
                                }
                            ),
                            animation: .default
                        )
                    }
                }
                .cancellable(id: CancelID.loadTransactionsRequest)
            case let .loadTransactionsResponse(.success(transactionsBox)):
                state.isProgressBarShowed = false
                state.isTransactionRequestRunning = false
                state.transactionsApi = transactionsBox.transactionsApi
                state.sortedTransactions = transactionsBox.sortedTransactions
                state.categoryGroupedTransacions = transactionsBox.categoryGroupedTransacions
                return .none
            case .loadTransactionsResponse(.failure):
                state.isProgressBarShowed = false
                state.isTransactionRequestRunning = false
                return .send(.showNetworkAlert)
            case .path(_):
                return .none
            case .binding(_):
                return .none
            }
        }
    }
}
