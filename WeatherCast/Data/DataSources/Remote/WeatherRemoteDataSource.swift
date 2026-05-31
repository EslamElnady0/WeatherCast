//  WeatherRemoteDataSource.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import Foundation

final class WeatherRemoteDataSource: WeatherRemoteDataSourceProtocol {
    private let client: APIClient
    private let localeManager: LocaleManager

    init(client: APIClient, localeManager: LocaleManager) {
        self.client = client
        self.localeManager = localeManager
    }

    func fetchForecast(lat: Double, lng: Double) async throws -> ForecastResponseDTO {
        let endpoint = WeatherEndpoint.forecast(
            params: WeatherByCoordParams(
               // lat: 30.0444,
               // lng: 31.2357,
                lat: lat,
                lng: lng,
                days: 3,
                lang: localeManager.apiLanguage,
            )
        )
        return try await client.request(endpoint: endpoint)
    }

    func fetchCurrentWeather(lat: Double, lng: Double) async throws -> WeatherResponseDTO {
        let endpoint = WeatherEndpoint.currentWeather(
            params: WeatherByCoordParams(
                lat: lat,
                lng: lng,
                days: 1,
                lang: localeManager.apiLanguage,
            )
        )
        return try await client.request(endpoint: endpoint)
    }

    func searchCities(query: String) async throws -> [SearchResultDTO] {
        let endpoint = WeatherEndpoint.search(params: SearchParams(query: query))
        return try await client.request(endpoint: endpoint)
    }
}
