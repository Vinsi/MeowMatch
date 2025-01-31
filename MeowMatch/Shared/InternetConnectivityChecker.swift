//
//  InternetConnectivityChecker.swift
//  MeowMatch
//
//  Created by Vinsi.
//

import Foundation
import Network

final class InternetConnectivityChecker: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: #function)

    static let shared = InternetConnectivityChecker() // Singleton for global access

    @Published var isConnected: Bool = true
    @Published var connectionType: ConnectionType = .unknown

    enum ConnectionType {
        case wifi
        case cellular
        case wired
        case unknown
    }

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            DispatchQueue.main.async {
                log.logI("InternetConnected:\(path.status == .satisfied)\(path.status)")
                self.isConnected = path.status == .satisfied
                self.connectionType = self.getConnectionType(for: path)
            }
        }
        monitor.start(queue: queue)
    }

    private func getConnectionType(for path: NWPath) -> ConnectionType {
        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.cellular) {
            return .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            return .wired
        } else {
            return .unknown
        }
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
