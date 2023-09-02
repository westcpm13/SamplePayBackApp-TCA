import Combine
import Foundation
import ComposableArchitecture

enum TypePathComponents: String {
    case transactions
}

protocol UrlTransactionsBuilding {
    @Sendable
    func getUrl(for typePathComponents: TypePathComponents) -> URL?
}

struct UrlTransactionsBuilder: UrlTransactionsBuilding {
    @Dependency(\.transactionsConfiguration) private var configuration
    
    func getUrl(for typePathComponents: TypePathComponents) -> URL? {
        return configuration.baseUrl?.appendingPathComponent(typePathComponents.rawValue)
    }
}

extension DependencyValues {
    var urlTransactionsBuilder: UrlTransactionsBuilder {
        get { self[UrlTransactionsBuilderKey.self] }
        set { self[UrlTransactionsBuilderKey.self] = newValue }
    }
    
    private enum UrlTransactionsBuilderKey: DependencyKey {
        static let liveValue = UrlTransactionsBuilder()
        static let testValue = UrlTransactionsBuilder()
    }
}

