//  DomainAssembly.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import Swinject

final class DomainAssembly: Assembly {
    func assemble(container: Container) {
        container.register(HomeUseCaseProtocol.self) { resolver in
            HomeUseCase(
                weatherRepository: resolver.resolve(WeatherRepositoryProtocol.self)!,
                settingsRepository: resolver.resolve(SettingsRepositoryProtocol.self)!
            )
        }

        container.register(MapUseCaseProtocol.self) { resolver in
            MapUseCase(
                weatherRepository: resolver.resolve(WeatherRepositoryProtocol.self)!,
                settingsRepository: resolver.resolve(SettingsRepositoryProtocol.self)!
            )
        }

        container.register(SavedLocationsUseCaseProtocol.self) { resolver in
            SavedLocationsUseCase(
                weatherRepository: resolver.resolve(WeatherRepositoryProtocol.self)!
            )
        }
    }
}
