//  NetworkMonitor.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import Foundation
import Network
import Observation

@Observable
final class NetworkMonitor {
    private(set) var isConnected: Bool = true

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "com.weathercast.netmonitor")

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
