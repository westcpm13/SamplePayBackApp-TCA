import SwiftUI
import Transactions
import ComposableArchitecture

@main
struct WorldOfPAYBACKApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(store: appStore)
        }
    }
}

struct WorldOfPAYBACKApp_Previews: PreviewProvider {
    static var previews: some View {
        AppView(store: appStore)
    }
}
