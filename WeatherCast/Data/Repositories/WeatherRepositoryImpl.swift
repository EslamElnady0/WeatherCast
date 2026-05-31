//  WeatherRepositoryImpl.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import Foundation

final class WeatherRepositoryImpl: WeatherRepositoryProtocol {
    private let remote: WeatherRemoteDataSourceProtocol
    private let local: WeatherLocalDataSourceProtocol
    private let network: NetworkMonitor
    private let localeManager: LocaleManager

    init(
        remote: WeatherRemoteDataSourceProtocol,
        local: WeatherLocalDataSourceProtocol,
        network: NetworkMonitor,
        localeManager: LocaleManager
    ) {
        self.remote = remote
        self.local = local
        self.network = network
        self.localeManager = localeManager
    }

    func getForecast(lat: Double, lng: Double) async throws -> ForecastEntity {
        let key = "\(lat),\(lng),\(localeManager.apiLanguage)"

        if network.isConnected {
            let dto = try await remote.fetchForecast(lat: lat, lng: lng)
            try? local.saveForecast(dto, for: key)
            return dto.toDomain()
        }

        if let cached = local.loadForecast(for: key) {
            return cached.toDomain()
        }

        throw APIError.noInternet
    }

    func searchCities(query: String) async throws -> [SearchResultEntity] {
        let dtos = try await remote.searchCities(query: query)
        return dtos.map { $0.toDomain() }
    }

    func savedLocations() -> [SavedLocationModel] {
        local.savedLocations()
    }

    func addLocation(_ location: SavedLocationModel) throws {
        try local.addLocation(location)
    }

    func removeLocation(_ location: SavedLocationModel) throws {
        try local.removeLocation(location)
    }
}
