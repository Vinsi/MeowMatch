//
//  InternetConnectivityChecker.swift
//  MeowMatch
//
//  Created by Vinsi.
//

import Foundation
import Network

enum ConnectionType {
    case wifi
    case cellular
    case wired
    case unknown
}

final class InternetConnectivityCheckerImpl: ObservableObject {
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: #function)
    private let isMock: Bool

    init(isMock: Bool = false, isConnected: Bool = true, connectionType: ConnectionType = .unknown) {
        self.isMock = isMock
        self.isConnected = isConnected
        self.connectionType = connectionType
    }

    @Published var isConnected: Bool = true
    @Published var connectionType: ConnectionType = .unknown

    func startMonitoring() {

        guard !isMock else { return }

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
