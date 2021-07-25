//
//  NetworkMonitor.swift
//  GoldMiner
//
//  Created by Yifan Zhang on 2021-07-24.
//

import Network

class NetworkMonitor {
    static public let shared = NetworkMonitor()
    
    public var monitoring: Bool = false
    
    public var usingCellular: Bool = false
    
    public var reachable: Bool = false
    
    private let cellular: NWPathMonitor = {
        let monitor = NWPathMonitor(requiredInterfaceType: .cellular)
        monitor.pathUpdateHandler = { path in
            switch path.status {
            case .satisfied:
                shared.usingCellular = shared.wifi.currentPath.status == .unsatisfied
                shared.reachable = shared.wifi.currentPath.status == .satisfied
            default:
                shared.usingCellular = false
                shared.reachable = false
            }
        }
        return monitor
    }()
    
    private let wifi: NWPathMonitor = {
        let monitor = NWPathMonitor(requiredInterfaceType: .wifi)
        monitor.pathUpdateHandler = { path in
            switch path.status {
            case .satisfied:
                shared.usingCellular = false
                shared.reachable = shared.cellular.currentPath.status == .satisfied
            case .unsatisfied:
                shared.usingCellular = shared.cellular.currentPath.status == .satisfied
                shared.reachable = false
            default:
                shared.usingCellular = false
                shared.reachable = false
            }
        }
        return monitor
    }()
    
    public func start() {
        if monitoring {
            print("already started.")
            return
        }
        monitoring = true
        let queue = DispatchQueue(label: "Monitor")
        cellular.start(queue: queue)
        wifi.start(queue: queue)
    }
    
    public func stop() {
        monitoring = false
        cellular.cancel()
        wifi.cancel()
    }
}
