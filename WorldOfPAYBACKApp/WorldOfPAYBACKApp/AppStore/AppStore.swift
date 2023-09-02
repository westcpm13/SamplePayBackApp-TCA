import ComposableArchitecture
import Transactions
import SwiftUI

let appStore = Store(
    initialState: AppReducer.State()
) {
    AppReducer()
} withDependencies: {
    let appEnvironment = AppEnvironment()
    $0.transactionsConfiguration = TransactionsConfiguration(
        baseUrl: URL(string: appEnvironment.baseURL),
        isDemoUser: appEnvironment.isDemoUser
    )
}
