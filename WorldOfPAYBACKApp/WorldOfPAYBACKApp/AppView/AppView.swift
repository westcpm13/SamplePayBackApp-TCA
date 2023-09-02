import ComposableArchitecture
import Transactions
import SwiftUI

struct AppView: View {
    let store: Store<AppReducer.State, AppReducer.Action>
    
    var body: some View {
        NavigationStackStore(
            appStore.scope(state: \.path, action: AppReducer.Action.path)
        ) {
            Form {
                NavigationLink(
                    "Show Transactions",
                    state: TransactionsFeature.Path.State.transactionsScreen(.init())
                )
            }
            .navigationBarTitle("World of PAYBACK", displayMode: .inline)
        } destination: {
            switch $0 {
            case .transactionsScreen:
                CaseLet(
                    /TransactionsFeature.Path.State.transactionsScreen,
                     action: TransactionsFeature.Path.Action.transactionsScreen
                ) {
                    TransactionsView(store: $0)
                }
            case .transactionDetailsScreen(_):
                CaseLet(
                    /TransactionsFeature.Path.State.transactionDetailsScreen,
                     action: TransactionsFeature.Path.Action.transactionDetailsScreen
                ) {
                    TransactionsDetailsView(store: $0)
                }
            }
        }
    }
}
