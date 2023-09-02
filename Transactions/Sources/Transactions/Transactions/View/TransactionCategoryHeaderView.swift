import Combine
import ComposableArchitecture
import SwiftUI

struct TransactionCategoryHeaderView: View {
    let categoryString: String
    let sumTransactionsString: String
    
    @ViewBuilder
    var body: some View {
        VStack {
            HStack {
                Text("Category: \(categoryString)")
                    .bold()
                Spacer()
            }
            VStack {
                HStack {
                    Spacer()
                    Text("Total amount: \(sumTransactionsString)")
                        .bold()
                }
            }
            
        }
    }
}
