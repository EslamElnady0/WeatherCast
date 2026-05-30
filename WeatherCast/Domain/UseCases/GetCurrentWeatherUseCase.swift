//  GetCurrentWeatherUseCase.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import Foundation

protocol GetCurrentWeatherUseCaseProtocol {
    func execute(lat: Double, lng: Double) async throws -> ForecastEntity
}

final class GetCurrentWeatherUseCase: GetCurrentWeatherUseCaseProtocol {
    private let repository: WeatherRepositoryProtocol

    init(repository: WeatherRepositoryProtocol) {
        self.repository = repository
    }

    func execute(lat: Double, lng: Double) async throws -> ForecastEntity {
        try await repository.getForecast(lat: lat, lng: lng)
    }
}
