import ComposableArchitecture
import SwiftUI

public struct TransactionsDetailsView: View {
    private let store: StoreOf<TransactionDetailsFeature>
    
    public init(store: StoreOf<TransactionDetailsFeature>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                Color.gray
                    .opacity(0.3)
                VStack {
                    TransactionCellView(transaction: viewStore.transactionModel)
                        .foregroundColor(Color.white)
                        .padding(.horizontal, 16)
                        .background(Color.gray)
                    Spacer()
                }
            }
        }
    }
}

