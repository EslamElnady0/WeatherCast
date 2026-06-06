//  ViewFactory.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import SwiftUI

struct ViewFactory {
    private let resolver: ViewModelResolver

    init(resolver: ViewModelResolver = ViewModelResolver()) {
        self.resolver = resolver
    }

    func home() -> HomeView {
        HomeView(viewModel: resolver.home())
    }

    func hourlyForecast(
        day: ForecastDayEntity,
        isDay: Bool
    ) -> HourlyForecastView {
        HourlyForecastView(
            viewModel: resolver.hourlyForecast(day: day, isDay: isDay)
        )
    }

    func map(onLocationSaved: @escaping () -> Void) -> MapView {
        MapView(
            viewModel: resolver.map(onLocationSaved: onLocationSaved)
        )
    }

    func savedLocations(
        onSelect: @escaping (LocationCoordinateEntity) -> Void,
        onLocationsChanged: @escaping () -> Void
    ) -> SavedLocationsView {
        SavedLocationsView(
            viewModel: resolver.savedLocations(),
            onSelect: onSelect,
            onLocationsChanged: onLocationsChanged
        )
    }
}

private struct ViewFactoryKey: EnvironmentKey {
    static let defaultValue = ViewFactory()
}

extension EnvironmentValues {
    var viewFactory: ViewFactory {
        get { self[ViewFactoryKey.self] }
        set { self[ViewFactoryKey.self] = newValue }
    }
}
