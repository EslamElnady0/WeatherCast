//  HomeViewModel.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import Foundation
import Observation

enum HomeViewState {
    case idle
    case loading
    case needsLocationPermission
    case locationUnavailable
    case empty
    case loaded
    case error(String)
}

@Observable
final class HomeViewModel {
    var forecasts: [ForecastEntity] = []
    var savedLocations: [SavedLocationModel] = []
    var state: HomeViewState = .idle
    var currentPageIndex: Int = 0

    private let homeUseCase: HomeUseCaseProtocol

    init(homeUseCase: HomeUseCaseProtocol) {
        self.homeUseCase = homeUseCase
    }

    func loadAll() async {
        state = .loading
        apply(await homeUseCase.loadHome())
    }

    private func apply(_ result: HomeLoadResult) {
        switch result {
        case .needsLocationPermission:
            state = .needsLocationPermission
        case .locationUnavailable:
            state = .locationUnavailable
        case .empty:
            state = .empty
        case .failed(let message):
            state = .error(message)
        case .loaded(let forecasts, let savedLocations):
            self.forecasts = forecasts
            self.savedLocations = savedLocations
            state = .loaded
        }
    }

    func removeLocation(_ location: SavedLocationModel) {
        Task {
            state = .loading
            apply(await homeUseCase.removeLocation(location))
        }
    }

}
