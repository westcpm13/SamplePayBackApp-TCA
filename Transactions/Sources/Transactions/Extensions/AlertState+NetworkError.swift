import ComposableArchitecture

public extension AlertState where Action == TransactionsFeature.Action.Alert {
    static func showNetworkAlert() -> Self {
        Self {
            TextState("Connection error")
        } actions: {
            ButtonState(
                role: .destructive,
                action: .refreshTransactionsButtonTapped
            ) {
                TextState("Refresh Transactions")
            }
        }
    }
}
