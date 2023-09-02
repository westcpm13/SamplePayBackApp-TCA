import ComposableArchitecture
import Combine
import Foundation

struct TransactionsApiService: Sendable {
    var loadTransactions: @Sendable (
        _ configuration: TransactionsConfiguration,
        _ urlTransactionsBuilder: UrlTransactionsBuilding
    ) async throws -> Data
}

extension DependencyValues {
    var transactionsApiService: TransactionsApiService {
        get { self[TransactionsApiService.self] }
        set { self[TransactionsApiService.self] = newValue }
    }
}

extension TransactionsApiService: DependencyKey {
    static let liveValue = transactionsApiService
    static let testValue = transactionsApiService
    
    static let transactionsApiService = Self { configuration, urlTransactionsBuilder in
        guard let url = urlTransactionsBuilder.getUrl(for: .transactions) else {
            print("TransactionsApiService: ERROR: problem with url")
            return Data()
        }
        do {
            let (dataResponse, _) = try await URLSession.shared.data(from: url)
            return dataResponse
        } catch {
            //Handle it in future
            print("TransactionsApiService: ERROR URLSession  URL = \(url)")
        }
        return Data()
    }
}
