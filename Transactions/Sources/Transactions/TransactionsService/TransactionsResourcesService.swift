import ComposableArchitecture
import Combine
import Foundation

struct TransactionsResourcesService: Sendable {
    var loadTransactions: @Sendable () async throws -> Data
}

extension DependencyValues {
    var transactionsResourcesService: TransactionsResourcesService {
        get { self[TransactionsResourcesService.self] }
        set { self[TransactionsResourcesService.self] = newValue }
    }
}

extension TransactionsResourcesService: DependencyKey {
    static let liveValue = transactionsResourcesService
    static let testValue = transactionsResourcesService
    
    static let transactionsResourcesService = Self {
        return Bundle.module.dataFromResource("PBTransactions")
    }
}
