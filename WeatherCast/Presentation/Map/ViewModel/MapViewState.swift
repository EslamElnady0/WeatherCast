//  MapViewState.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import CoreLocation
import MapKit

enum MapPreviewState {
    case idle
    case loading
    case loaded
    case error(String)
}

struct MapViewState {
    var selectedCoordinate: CLLocationCoordinate2D?
    var previewForecast: ForecastEntity?
    var previewState: MapPreviewState = .idle
    var isAlreadySaved: Bool = false
    var isSheetPresented: Bool = false
    var searchQuery: String = ""
    var searchResults: [SearchResultEntity] = []
    var searchErrorMessage: String?
    var isSearching: Bool = false
    var shouldDismiss: Bool = false
    var requestedRegion: MKCoordinateRegion?
    var cameraUpdateID: Int = 0
}

enum MapViewAction {
    case loadInitialPosition
    case initialCoordinateLoaded(LocationCoordinateEntity?)
    case mapTapped(CLLocationCoordinate2D)
    case searchResultSelected(SearchResultEntity)
    case searchQueryChanged(String)
    case sheetPresentationChanged(Bool)
    case addToFavourites
    case previewLoaded(ForecastEntity, isAlreadySaved: Bool)
    case previewFailed(String)
    case searchResultsLoaded([SearchResultEntity])
    case searchFailed(String)
    case favouriteSaved
    case favouriteAlreadySaved
    case favouriteFailed(String)
    case dismissHandled
}

enum MapViewEffect {
    case loadInitialPosition
    case previewForecast(CLLocationCoordinate2D)
    case searchCities(String)
    case cancelSearch
    case addToFavourites(ForecastEntity)
    case locationSaved
}

enum MapViewStateHandler {
    static func reduce(
        state: inout MapViewState,
        action: MapViewAction
    ) -> [MapViewEffect] {
        switch action {
        case .loadInitialPosition:
            return [.loadInitialPosition]
        case .initialCoordinateLoaded(let coordinate):
            guard let coordinate else { return [] }
            updateCameraRegion(
                state: &state,
                region: region(
                    centeredAt: CLLocationCoordinate2D(
                        latitude: coordinate.lat,
                        longitude: coordinate.lng
                    )
                )
            )
        case .mapTapped(let coordinate):
            selectCoordinate(state: &state, coordinate: coordinate)
            return [.previewForecast(coordinate)]
        case .searchResultSelected(let result):
            state.searchQuery = ""
            state.searchResults = []
            state.searchErrorMessage = nil
            state.isSearching = false

            let coordinate = CLLocationCoordinate2D(latitude: result.lat, longitude: result.lng)
            updateCameraRegion(state: &state, region: region(centeredAt: coordinate))
            selectCoordinate(state: &state, coordinate: coordinate)
            return [.cancelSearch, .previewForecast(coordinate)]
        case .searchQueryChanged(let query):
            state.searchQuery = query
            state.searchErrorMessage = nil

            guard query.count >= 2 else {
                state.searchResults = []
                state.isSearching = false
                return [.cancelSearch]
            }

            state.isSearching = true
            return [.searchCities(query)]
        case .sheetPresentationChanged(let isPresented):
            state.isSheetPresented = isPresented
        case .addToFavourites:
            guard let forecast = state.previewForecast else { return [] }
            return [.addToFavourites(forecast)]
        case .previewLoaded(let forecast, let isAlreadySaved):
            state.previewForecast = forecast
            state.isAlreadySaved = isAlreadySaved
            state.previewState = .loaded
        case .previewFailed(let message):
            state.previewState = .error(message)
        case .searchResultsLoaded(let results):
            state.searchResults = results
            state.searchErrorMessage = nil
            state.isSearching = false
        case .searchFailed(let message):
            state.searchResults = []
            state.searchErrorMessage = message
            state.isSearching = false
        case .favouriteSaved:
            state.isSheetPresented = false
            state.shouldDismiss = true
            return [.locationSaved]
        case .favouriteAlreadySaved:
            state.isAlreadySaved = true
        case .favouriteFailed(let message):
            state.previewState = .error(message)
        case .dismissHandled:
            state.shouldDismiss = false
        }

        return []
    }

    private static func selectCoordinate(
        state: inout MapViewState,
        coordinate: CLLocationCoordinate2D
    ) {
        state.selectedCoordinate = coordinate
        state.previewForecast = nil
        state.previewState = .loading
        state.isAlreadySaved = false
        state.isSheetPresented = true
    }

    private static func updateCameraRegion(
        state: inout MapViewState,
        region: MKCoordinateRegion
    ) {
        state.requestedRegion = region
        state.cameraUpdateID += 1
    }

    private static func region(centeredAt coordinate: CLLocationCoordinate2D) -> MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 50_000,
            longitudinalMeters: 50_000
        )
    }
}
