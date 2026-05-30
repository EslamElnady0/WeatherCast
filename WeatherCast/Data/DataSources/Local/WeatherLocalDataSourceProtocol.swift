//  WeatherLocalDataSourceProtocol.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import Foundation

protocol WeatherLocalDataSourceProtocol {
    func saveForecast(_ dto: ForecastResponseDTO, for key: String) throws
    func loadForecast(for key: String) -> ForecastResponseDTO?
    func savedLocations() -> [SavedLocationModel]
    func addLocation(_ location: SavedLocationModel) throws
    func removeLocation(_ location: SavedLocationModel) throws
}
