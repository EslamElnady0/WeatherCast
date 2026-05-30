//  SearchCitiesUseCase.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import Foundation

protocol SearchCitiesUseCaseProtocol {
    func execute(query: String) async throws -> [SearchResultEntity]
}

final class SearchCitiesUseCase: SearchCitiesUseCaseProtocol {
    private let repository: WeatherRepositoryProtocol

    init(repository: WeatherRepositoryProtocol) {
        self.repository = repository
    }

    func execute(query: String) async throws -> [SearchResultEntity] {
        guard query.count >= 2 else { return [] }
        return try await repository.searchCities(query: query)
    }
}
