import ComposableArchitecture
import XCTest
@testable import Transactions

@MainActor
final class TransactionsTests: XCTestCase {
    
    func testNetworkAlert_ShouldShowWhenActionAhowNetworkAlertCalled() async {
        let store = getTestStore()
        
        await store.send(.showNetworkAlert) {
            $0.alert = .showNetworkAlert()
        }
    }
    
    func testNetworkAlertShouldCallLoadTransactionActionWhenRefreshTransactionsButtonTapped() async {
        let store = getTestStore()
        
        store.exhaustivity = .off
        
        await store.send(.showNetworkAlert)
        
        await store.send(.alert(.presented(.refreshTransactionsButtonTapped))) {
            $0.alert = nil
        }
        await store.receive(.loadTransactions(fromPullToRefresh: false))
    }
    
    func testNetworkAlert_ShouldResetAlertStateWhenDismiss() async {
        let store = getTestStore()
        
        store.exhaustivity = .off
        
        await store.send(.showNetworkAlert)
        
        await store.send(.alert(.dismiss)) {
            $0.alert = nil
        }
    }
}

private extension TransactionsTests {
    func getTestStore() -> TestStore<TransactionsFeature.State, TransactionsFeature.Action> {
        let clock = TestClock()
        let store = TestStore(initialState: TransactionsFeature.State()) {
            TransactionsFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }
        return store
    }
}
