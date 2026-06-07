//  PresentationAssembly.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import Swinject

final class PresentationAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(HomeViewModel.self) { resolver in
            HomeViewModel(
                homeUseCase: resolver.resolve(HomeUseCaseProtocol.self)!,
                connectivityMonitor: resolver.resolve(
                    InternetConnectivityMonitor.self
                )!
            )
        }

        container.register(HourlyForecastViewModel.self) { _, day, isDay in
            HourlyForecastViewModel(day: day, isDay: isDay)
        }

        container.register(MapViewModel.self) { resolver, onLocationSaved in
            MapViewModel(
                mapUseCase: resolver.resolve(MapUseCaseProtocol.self)!,
                onLocationSaved: onLocationSaved
            )
        }

        container.register(SavedLocationsViewModel.self) { resolver in
            SavedLocationsViewModel(
                savedLocationsUseCase: resolver.resolve(SavedLocationsUseCaseProtocol.self)!
            )
        }
    }
}
