import SwiftUI
import ComposableArchitecture

public struct TransactionsConfiguration: Sendable {
    public let isDemoUser: Bool
    public let baseUrl: URL?
    
    public init(baseUrl: URL? = nil, isDemoUser: Bool = true) {
        self.isDemoUser = isDemoUser
        self.baseUrl = baseUrl
    }
}

extension DependencyValues {
    public var transactionsConfiguration: TransactionsConfiguration {
        get { self[TransactionsConfigurationKey.self] }
        set { self[TransactionsConfigurationKey.self] = newValue }
    }
    
    private enum TransactionsConfigurationKey: DependencyKey {
        static let liveValue = TransactionsConfiguration()
        static let testValue = TransactionsConfiguration()
    }
}
