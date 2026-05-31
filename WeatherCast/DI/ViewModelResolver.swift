//  ViewModelResolver.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

struct ViewModelResolver {
    private let container: AppContainer

    init(container: AppContainer = .shared) {
        self.container = container
    }

    func home() -> HomeViewModel {
        container.resolve(HomeViewModel.self)
    }

    func map(onLocationSaved: @escaping () -> Void) -> MapViewModel {
        container.resolve(MapViewModel.self, argument: onLocationSaved)
    }

    func savedLocations() -> SavedLocationsViewModel {
        container.resolve(SavedLocationsViewModel.self)
    }
}
