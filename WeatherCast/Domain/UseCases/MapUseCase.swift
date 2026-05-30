//  MapUseCase.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import Foundation

struct MapPreviewResult {
    let forecast: ForecastEntity
    let isAlreadySaved: Bool
}

enum AddFavouriteResult {
    case saved
    case alreadySaved
}

protocol MapUseCaseProtocol {
    func initialCoordinate() async -> LocationCoordinateEntity?
    func previewForecast(at coordinate: LocationCoordinateEntity) async throws -> MapPreviewResult
    func searchCities(query: String) async throws -> [SearchResultEntity]
    func addToFavourites(_ forecast: ForecastEntity) throws -> AddFavouriteResult
}

final class MapUseCase: MapUseCaseProtocol {
    private let weatherRepository: WeatherRepositoryProtocol
    private let settingsRepository: SettingsRepositoryProtocol

    init(
        weatherRepository: WeatherRepositoryProtocol,
        settingsRepository: SettingsRepositoryProtocol
    ) {
        self.weatherRepository = weatherRepository
        self.settingsRepository = settingsRepository
    }

    func initialCoordinate() async -> LocationCoordinateEntity? {
        settingsRepository.requestLocationIfNeeded()
        return await settingsRepository.currentCoordinateWithWait()
    }

    func previewForecast(at coordinate: LocationCoordinateEntity) async throws -> MapPreviewResult {
        let forecast = try await weatherRepository.getForecast(
            lat: coordinate.lat,
            lng: coordinate.lng
        )
        return MapPreviewResult(
            forecast: forecast,
            isAlreadySaved: isSaved(forecast)
        )
    }

    func searchCities(query: String) async throws -> [SearchResultEntity] {
        guard query.count >= 2 else { return [] }
        return try await weatherRepository.searchCities(query: query)
    }

    func addToFavourites(_ forecast: ForecastEntity) throws -> AddFavouriteResult {
        guard !isSaved(forecast) else { return .alreadySaved }

        let savedLocations = weatherRepository.savedLocations()
        let location = SavedLocationModel(
            name: forecast.location.locationName,
            lat: forecast.location.lat,
            lng: forecast.location.lng,
            sortOrder: savedLocations.count
        )
        try weatherRepository.addLocation(location)
        return .saved
    }

    private func isSaved(_ forecast: ForecastEntity) -> Bool {
        weatherRepository.savedLocations().contains {
            $0.lat == forecast.location.lat && $0.lng == forecast.location.lng
        }
    }
}
