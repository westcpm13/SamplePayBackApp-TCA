import Combine
import ComposableArchitecture
import SwiftUI

struct TransactionCellView: View {
    let transaction: TransactionModel
    
    private var amountText: String {
        let amount = "\(transaction.transactionDetail?.amount?.value ?? 0)"
        let currency = transaction.transactionDetail?.amount?.currency ?? ""
        return [amount, currency].joined(separator:" ")
    }
    
    @ViewBuilder
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                Text("Name:")
                    .bold()
                Text(transaction.partnerDisplayName)
                Spacer()
                VStack {
                    Text("Amount")
                        .bold()
                    Text(amountText)
                }
            }
            HStack(spacing: 8) {
                Text("Booking Date:")
                    .bold()
                Text(transaction.transactionDetail?.bookingFormatted ?? "")
                Spacer()
            }
            HStack(spacing: 8) {
                Text("Description:")
                    .bold()
                Text(transaction.transactionDetail?.description ?? "")
                Spacer()
            }
            .padding(.bottom, 8)
        }
    }
}
