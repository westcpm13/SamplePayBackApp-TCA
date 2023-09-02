import Combine
import ComposableArchitecture
import SwiftUI

struct PickerSegmentView: View {
    let viewStore: ViewStoreOf<TransactionsFeature>
    
    var body: some View {
        
        Picker("Filter", selection: viewStore.$filter.animation()) {
            ForEach(Filter.allCases, id: \.self) { filter in
                Text(filter.rawValue).tag(filter)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
}
