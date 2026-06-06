//  MapViewModel.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import CoreLocation
import Observation

@Observable
final class MapViewModel {
    private(set) var state = MapViewState()

    private let mapUseCase: MapUseCaseProtocol
    private let onLocationSaved: () -> Void
    private var initialPositionTask: Task<Void, Never>?
    private var searchTask: Task<Void, Never>?
    private var previewTask: Task<Void, Never>?

    init(
        mapUseCase: MapUseCaseProtocol,
        onLocationSaved: @escaping () -> Void
    ) {
        self.mapUseCase = mapUseCase
        self.onLocationSaved = onLocationSaved
    }

    func send(_ action: MapViewAction) {
        let effects = MapViewStateHandler.reduce(state: &state, action: action)
        for effect in effects {
            run(effect)
        }
    }

    private func run(_ effect: MapViewEffect) {
        switch effect {
        case .loadInitialPosition:
            loadInitialPosition()
        case .previewForecast(let coordinate):
            loadPreview(at: coordinate)
        case .searchCities(let query):
            searchCities(query: query)
        case .cancelSearch:
            searchTask?.cancel()
        case .addToFavourites(let forecast):
            addToFavourites(forecast)
        case .locationSaved:
            onLocationSaved()
        }
    }

    private func loadInitialPosition() {
        initialPositionTask?.cancel()
        initialPositionTask = Task {
            let coordinate = await mapUseCase.initialCoordinate()
            guard !Task.isCancelled else { return }
            send(.initialCoordinateLoaded(coordinate))
        }
    }

    private func loadPreview(at coordinate: CLLocationCoordinate2D) {
        previewTask?.cancel()
        previewTask = Task {
            do {
                let result = try await mapUseCase.previewForecast(
                    at: LocationCoordinateEntity(
                        lat: coordinate.latitude,
                        lng: coordinate.longitude
                    )
                )
                guard !Task.isCancelled else { return }
                send(.previewLoaded(result.forecast, isAlreadySaved: result.isAlreadySaved))
            } catch {
                guard !Task.isCancelled else { return }
                send(.previewFailed(error.localizedDescription))
            }
        }
    }

    private func searchCities(query: String) {
        searchTask?.cancel()
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 350_000_000)
            guard !Task.isCancelled else { return }

            do {
                let results = try await mapUseCase.searchCities(query: query)
                guard !Task.isCancelled else { return }
                send(.searchResultsLoaded(results))
            } catch {
                guard !Task.isCancelled else { return }
                send(.searchFailed(error.localizedDescription))
            }
        }
    }

    private func addToFavourites(_ forecast: ForecastEntity) {
        do {
            switch try mapUseCase.addToFavourites(forecast) {
            case .saved:
                send(.favouriteSaved)
            case .alreadySaved:
                send(.favouriteAlreadySaved)
            }
        } catch {
            send(.favouriteFailed(error.localizedDescription))
        }
    }
}
