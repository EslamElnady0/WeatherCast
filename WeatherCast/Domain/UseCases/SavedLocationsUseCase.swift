//  SavedLocationsUseCase.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import Foundation

struct SavedLocationForecast {
    let location: SavedLocationModel
    let forecast: ForecastEntity?
}

protocol SavedLocationsUseCaseProtocol {
    func loadSavedLocations() async -> [SavedLocationForecast]
}

final class SavedLocationsUseCase: SavedLocationsUseCaseProtocol {
    private let weatherRepository: WeatherRepositoryProtocol

    init(weatherRepository: WeatherRepositoryProtocol) {
        self.weatherRepository = weatherRepository
    }

    func loadSavedLocations() async -> [SavedLocationForecast] {
        var results: [SavedLocationForecast] = []

        for location in weatherRepository.savedLocations() {
            let forecast = try? await weatherRepository.getForecast(
                lat: location.lat,
                lng: location.lng
            )
            results.append(
                SavedLocationForecast(
                    location: location,
                    forecast: forecast
                )
            )
        }

        return results
    }
}
