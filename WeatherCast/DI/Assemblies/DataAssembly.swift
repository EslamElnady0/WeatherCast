//  DataAssembly.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import SwiftData
import Swinject

final class DataAssembly: Assembly {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func assemble(container: Container) {
        container.register(WeatherRemoteDataSourceProtocol.self) { resolver in
            WeatherRemoteDataSource(client: resolver.resolve(APIClient.self)!)
        }
        .inObjectScope(.container)

        container.register(WeatherLocalDataSourceProtocol.self) { [modelContext] _ in
            WeatherLocalDataSource(context: modelContext)
        }
        .inObjectScope(.container)

        container.register(SettingsLocalDataSourceProtocol.self) { resolver in
            SettingsLocalDataSource(
                locationManager: resolver.resolve(LocationManagerProtocol.self)!
            )
        }
        .inObjectScope(.container)

        container.register(WeatherRepositoryProtocol.self) { resolver in
            WeatherRepositoryImpl(
                remote: resolver.resolve(WeatherRemoteDataSourceProtocol.self)!,
                local: resolver.resolve(WeatherLocalDataSourceProtocol.self)!,
                network: resolver.resolve(NetworkMonitor.self)!
            )
        }
        .inObjectScope(.container)

        container.register(SettingsRepositoryProtocol.self) { resolver in
            SettingsRepositoryImpl(
                localDataSource: resolver.resolve(SettingsLocalDataSourceProtocol.self)!
            )
        }
        .inObjectScope(.container)
    }
}
