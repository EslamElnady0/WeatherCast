//  WeatherLocalDataSource.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import Foundation
import SwiftData

final class WeatherLocalDataSource: WeatherLocalDataSourceProtocol {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func saveForecast(_ dto: ForecastResponseDTO, for key: String) throws {
        let data = try JSONEncoder().encode(dto)
        let existing = try context.fetch(
            FetchDescriptor<CachedWeatherModel>(
                predicate: #Predicate { $0.locationKey == key }
            )
        ).first

        if let existing {
            existing.jsonData = data
            existing.cachedAt = Date()
        } else {
            context.insert(CachedWeatherModel(locationKey: key, jsonData: data))
        }

        try context.save()
    }

    func loadForecast(for key: String) -> ForecastResponseDTO? {
        let results = try? context.fetch(
            FetchDescriptor<CachedWeatherModel>(
                predicate: #Predicate { $0.locationKey == key }
            )
        )
        guard let data = results?.first?.jsonData else { return nil }
        return try? JSONDecoder().decode(ForecastResponseDTO.self, from: data)
    }

    func savedLocations() -> [SavedLocationModel] {
        (try? context.fetch(
            FetchDescriptor<SavedLocationModel>(
                sortBy: [SortDescriptor(\SavedLocationModel.sortOrder)]
            )
        )) ?? []
    }

    func addLocation(_ location: SavedLocationModel) throws {
        context.insert(location)
        try context.save()
    }

    func removeLocation(_ location: SavedLocationModel) throws {
        context.delete(location)
        try context.save()
    }
}
