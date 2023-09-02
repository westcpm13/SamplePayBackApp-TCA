import Combine
import ComposableArchitecture
import Network
import SwiftUI

protocol NetworkPathMonitorProtocol {
    var pathUpdateHandler: ((_ newPath: NWPath) -> Void)? { get set }
    func start(queue: DispatchQueue)
    func cancel()
}

extension NWPathMonitor: NetworkPathMonitorProtocol {}

final class NetworkMonitor {
    let networkStatus = PassthroughSubject<Bool, Never>()
    private(set) var onWifi = true
    private(set) var onCellular = true
    private var pathMonitor: NetworkPathMonitorProtocol
    private let monitorQueue = DispatchQueue(label: "NetworkMonitor")

    init(
        pathMonitor: NetworkPathMonitorProtocol = NWPathMonitor()
    ) {
        self.pathMonitor = pathMonitor
        setupPathMonitor()
        startMonitoring()
    }
    
    func startMonitoring() {
        pathMonitor.start(queue: monitorQueue)
    }
    
    func cancelMonitoring() {
        pathMonitor.cancel()
    }

    private func setupPathMonitor() {
        pathMonitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.networkStatus.send(path.status == .satisfied)
                self.onWifi = path.usesInterfaceType(.wifi)
                self.onCellular = path.usesInterfaceType(.cellular)
            }
        }
    }
}

extension DependencyValues {
    var networkMonitor: NetworkMonitor {
        get { self[NetworkMonitorKey.self] }
        set { self[NetworkMonitorKey.self] = newValue }
    }
    
    private enum NetworkMonitorKey: DependencyKey {
        static let liveValue = NetworkMonitor()
        static let testValue = NetworkMonitor()
    }
}
