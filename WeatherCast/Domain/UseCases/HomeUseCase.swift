//  HomeUseCase.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import Foundation

enum HomeLoadResult {
    case needsLocationPermission
    case locationUnavailable
    case empty
    case loaded(forecasts: [ForecastEntity], savedLocations: [SavedLocationModel])
    case failed(message: String)
}

protocol HomeUseCaseProtocol {
    func loadHome() async -> HomeLoadResult
    func removeLocation(_ location: SavedLocationModel) async -> HomeLoadResult
}

final class HomeUseCase: HomeUseCaseProtocol {
    private let weatherRepository: WeatherRepositoryProtocol
    private let settingsRepository: SettingsRepositoryProtocol

    init(
        weatherRepository: WeatherRepositoryProtocol,
        settingsRepository: SettingsRepositoryProtocol
    ) {
        self.weatherRepository = weatherRepository
        self.settingsRepository = settingsRepository
    }

    func loadHome() async -> HomeLoadResult {
        settingsRepository.requestLocationIfNeeded()

        let savedLocations = weatherRepository.savedLocations()

        var locations: [(lat: Double, lng: Double)] = []
        if let coord = await settingsRepository.currentCoordinateWithWait() {
            locations.append((coord.lat, coord.lng))
        }
        locations += savedLocations.map { ($0.lat, $0.lng) }

        if locations.isEmpty {
            return fallbackResultForMissingLocations()
        }

        var forecasts: [ForecastEntity] = []
        var lastError: Error?

        for location in locations {
            do {
                let forecast = try await weatherRepository.getForecast(
                    lat: location.lat,
                    lng: location.lng
                )
                forecasts.append(forecast)
            } catch {
                lastError = error
            }
        }

        if !forecasts.isEmpty {
            return .loaded(forecasts: forecasts, savedLocations: savedLocations)
        }

        if let lastError {
            return .failed(message: lastError.localizedDescription)
        }

        return .empty
    }

    func removeLocation(_ location: SavedLocationModel) async -> HomeLoadResult {
        do {
            try weatherRepository.removeLocation(location)
        } catch {
            return .failed(message: error.localizedDescription)
        }

        return await loadHome()
    }

    private func fallbackResultForMissingLocations() -> HomeLoadResult {
        switch settingsRepository.locationAccessState() {
        case .needsPermission:
            return .needsLocationPermission
        case .unavailable:
            return .locationUnavailable
        case .available:
            return .empty
        }
    }
}
