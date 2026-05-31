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
                homeUseCase: resolver.resolve(HomeUseCaseProtocol.self)!
            )
        }

        container.register(MapViewModel.self) { resolver, onLocationSaved in
            MapViewModel(
                mapUseCase: resolver.resolve(MapUseCaseProtocol.self)!,
                onLocationSaved: onLocationSaved
            )
        }
    }
}
