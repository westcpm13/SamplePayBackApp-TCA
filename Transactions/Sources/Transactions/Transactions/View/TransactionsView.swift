import Combine
import ComposableArchitecture
import SwiftUI

public struct TransactionsView: View {
    private let store: StoreOf<TransactionsFeature>
    @State private var isViewLoadingFirstTime = true
    @Dependency(\.networkMonitor.networkStatus) private var networkStatus
    
    public init(store: StoreOf<TransactionsFeature>) {
        self.store = store
    }
    
    var progressBarView: some View {
        GeometryReader { geometry in
            ProgressView()
                .scaleEffect(1.5)
                .position(
                    x: geometry.size.width / 2,
                    y: geometry.size.height / 2
                )
        }
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                VStack(spacing: 16) {
                    PickerSegmentView(viewStore: viewStore)
                    List {
                        if viewStore.filter == .sortedTransactions {
                            ForEach(viewStore.sortedTransactions) { transaction in
                                NavigationLink(
                                    state: TransactionsFeature.Path.State.transactionDetailsScreen(.init(transactionModel: transaction))) {
                                        TransactionCellView(transaction: transaction)
                                    }
                            }
                        } else {
                            ForEach(viewStore.categoryGroupedTransacions) { groupedTransactionModel in
                                Section(
                                    header: TransactionCategoryHeaderView(
                                        categoryString: groupedTransactionModel.categoryString,
                                        sumTransactionsString: groupedTransactionModel.sumTransactionsString
                                    )
                                ) {
                                    ForEach(groupedTransactionModel.transactions) { transaction in
                                        NavigationLink(
                                            state: TransactionsFeature.Path.State.transactionDetailsScreen(.init(transactionModel: transaction))) {
                                                TransactionCellView(transaction: transaction)
                                            }
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(.inset)
                    .listRowInsets(EdgeInsets())
                    .opacity(isViewLoadingFirstTime ? 0 : 1)
                    .refreshable {
                        await viewStore.send(.loadTransactions(fromPullToRefresh: true)).finish()
                    }
                }
                
                if viewStore.state.isProgressBarShowed {
                    progressBarView
                        .edgesIgnoringSafeArea(.all)
                }
            }
            .onReceive(networkStatus) {
                guard !$0 else { return }
                viewStore.send(.showNetworkAlert)                
            }
            .task {
                guard isViewLoadingFirstTime else { return }
                await viewStore.send(.loadTransactions(fromPullToRefresh: false)).finish()
                isViewLoadingFirstTime = false
            }
            .alert(
                store: self.store.scope(
                    state: \.$alert,
                    action: { .alert($0) }
                )
            )
        }
    }
}
