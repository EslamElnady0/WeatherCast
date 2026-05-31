//  NetworkAssembly.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import Swinject

final class NetworkAssembly: Assembly {
    func assemble(container: Container) {
        container.register(APIClient.self) { _ in
            APIClient()
        }
        .inObjectScope(.container)

        container.register(NetworkMonitor.self) { _ in
            NetworkMonitor()
        }
        .inObjectScope(.container)
    }
}
