//  InternetConnectivityMonitor.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 06/06/2026.
//

import Alamofire
import Observation

@Observable
final class InternetConnectivityMonitor {
    private(set) var isConnected = true

    private let reachabilityManager: NetworkReachabilityManager?

    init(
        reachabilityManager: NetworkReachabilityManager? = .default
    ) {
        self.reachabilityManager = reachabilityManager
        startMonitoring()
    }

    private func startMonitoring() {
        reachabilityManager?.startListening { [weak self] status in
            switch status {
            case .reachable:
                self?.isConnected = true
            case .notReachable:
                self?.isConnected = false
            case .unknown:
                break
            }
        }
    }
}
