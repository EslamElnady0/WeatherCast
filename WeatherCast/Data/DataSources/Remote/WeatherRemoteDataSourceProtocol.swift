//  WeatherRemoteDataSourceProtocol.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import Foundation

protocol WeatherRemoteDataSourceProtocol {
    func fetchForecast(lat: Double, lng: Double) async throws -> ForecastResponseDTO
    func fetchCurrentWeather(lat: Double, lng: Double) async throws -> WeatherResponseDTO
    func searchCities(query: String) async throws -> [SearchResultDTO]
}
