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
        case .loaded(let forecasts):
            self.forecasts = forecasts
            currentPageIndex = min(currentPageIndex, max(forecasts.count - 1, 0))
            state = .loaded
        }
    }

    func requestLocationPermission() {
        Task {
            state = .loading
            apply(await homeUseCase.requestLocationPermission())
        }
    }

    func selectLocation(at coordinate: LocationCoordinateEntity) {
        guard let index = forecasts.firstIndex(where: {
            $0.location.lat == coordinate.lat && $0.location.lng == coordinate.lng
        }) else {
            return
        }

        currentPageIndex = index
    }
}
