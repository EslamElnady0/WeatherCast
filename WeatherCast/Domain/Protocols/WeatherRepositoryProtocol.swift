//  WeatherRepositoryProtocol.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import Foundation

protocol WeatherRepositoryProtocol {
    func getForecast(lat: Double, lng: Double) async throws -> ForecastEntity
    func searchCities(query: String) async throws -> [SearchResultEntity]
    func savedLocations() -> [SavedLocationModel]
    func addLocation(_ location: SavedLocationModel) throws
    func removeLocation(_ location: SavedLocationModel) throws
}
