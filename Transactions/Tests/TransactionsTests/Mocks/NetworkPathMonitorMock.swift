import Network
@testable import Transactions

final class NetworkPathMonitorMock: NetworkPathMonitorProtocol {
    var currentPathStatus: NWPath.Status
    var pathUpdateHandler: ((NWPath) -> Void)?
    var startMethodCalled = false
    var cancelMethodCalled = false
    
    init(currentPathStatus: NWPath.Status = .satisfied) {
        self.currentPathStatus = currentPathStatus        
    }
    
    func start(queue: DispatchQueue) {
        startMethodCalled = true
    }
    
    func cancel() {
        cancelMethodCalled = true
    }
}
