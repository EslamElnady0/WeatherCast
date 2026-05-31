//  SavedLocationsViewModel.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import Foundation
import Observation

enum SavedLocationsViewState {
    case idle
    case loading
    case empty
    case loaded
}

struct SavedLocationRow: Identifiable {
    let location: SavedLocationModel
    let forecast: ForecastEntity?

    var id: UUID {
        location.id
    }
}

@Observable
final class SavedLocationsViewModel {
    private(set) var rows: [SavedLocationRow] = []
    private(set) var state: SavedLocationsViewState = .idle
    private(set) var deletionErrorMessage: String?

    private let savedLocationsUseCase: SavedLocationsUseCaseProtocol

    init(savedLocationsUseCase: SavedLocationsUseCaseProtocol) {
        self.savedLocationsUseCase = savedLocationsUseCase
    }

    func load() async {
        state = .loading
        rows = await savedLocationsUseCase.loadSavedLocations().map {
            SavedLocationRow(location: $0.location, forecast: $0.forecast)
        }
        state = rows.isEmpty ? .empty : .loaded
    }

    func remove(_ row: SavedLocationRow) -> Bool {
        do {
            try savedLocationsUseCase.removeLocation(row.location)
            rows.removeAll { $0.id == row.id }
            state = rows.isEmpty ? .empty : .loaded
            return true
        } catch {
            deletionErrorMessage = error.localizedDescription
            return false
        }
    }

    func clearDeletionError() {
        deletionErrorMessage = nil
    }
}
