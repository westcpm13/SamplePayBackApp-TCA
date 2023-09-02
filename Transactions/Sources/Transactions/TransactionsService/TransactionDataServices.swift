import ComposableArchitecture
import Combine
import Foundation

struct TransactionDataServicesModel {
    @Dependency(\.transactionsApiService) var transactionsApiService
    @Dependency(\.transactionsResourcesService) var transactionsResourcesService
    @Dependency(\.transactionsConfiguration) var transactionsConfiguration
    @Dependency(\.urlTransactionsBuilder) var urlTransactionsBuilder
    @Dependency(\.uuid) var uuid
}

extension TransactionDataServicesModel: DependencyKey {
    static let liveValue = transactionDataServicesModel
    static let testValue = transactionDataServicesModel
    static let transactionDataServicesModel = Self()
}

extension DependencyValues {
    var transactionDataServicesModel: TransactionDataServicesModel {
        get { self[TransactionDataServicesModel.self] }
        set { self[TransactionDataServicesModel.self] = newValue }
    }
}

protocol TransactionDataServicing {
    func loadTransactionsData(with transactionDataServicesModel: TransactionDataServicesModel) async throws -> Data
}

struct TransactionDataServices: Sendable, TransactionDataServicing {
    func loadTransactionsData(with transactionDataServicesModel: TransactionDataServicesModel) async throws -> Data {
        if transactionDataServicesModel.transactionsConfiguration.isDemoUser {
            let data = try await transactionDataServicesModel
                .transactionsResourcesService
                .loadTransactions()
            return data
        } else {
            let data = try await transactionDataServicesModel
                .transactionsApiService
                .loadTransactions(
                    transactionDataServicesModel.transactionsConfiguration,
                    transactionDataServicesModel.urlTransactionsBuilder
                )
            return data
        }
    }
}

extension DependencyValues {
    var transactionDataServices: TransactionDataServices {
        get { self[TransactionDataServices.self] }
        set { self[TransactionDataServices.self] = newValue }
    }
}

extension TransactionDataServices: DependencyKey {
    static let liveValue = transactionDataServices
    static let testValue = transactionDataServices
    static let transactionDataServices = Self()
}
