//  WeatherRemoteDataSource.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import Foundation

final class WeatherRemoteDataSource: WeatherRemoteDataSourceProtocol {
    private let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func fetchForecast(lat: Double, lng: Double) async throws -> ForecastResponseDTO {
        let endpoint = WeatherEndpoint.forecast(
            params: WeatherByCoordParams(
                lat: lat,
                lng: lng,
                days: 3,
                lang: "en",
                aqi: "no",
                alerts: "no"
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
                lang: "en",
                aqi: "no",
                alerts: "no"
            )
        )
        return try await client.request(endpoint: endpoint)
    }

    func searchCities(query: String) async throws -> [SearchResultDTO] {
        let endpoint = WeatherEndpoint.search(params: SearchParams(query: query))
        return try await client.request(endpoint: endpoint)
    }
}
