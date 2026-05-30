//  SettingsRepositoryImpl.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import CoreLocation
import Foundation

final class SettingsRepositoryImpl: SettingsRepositoryProtocol {
    private let localDataSource: SettingsLocalDataSourceProtocol

    init(localDataSource: SettingsLocalDataSourceProtocol) {
        self.localDataSource = localDataSource
    }

    func requestLocationIfNeeded() {
        if localDataSource.authorizationStatus == .notDetermined {
            localDataSource.requestPermission()
        } else if localDataSource.authorizationStatus == .authorizedWhenInUse ||
                    localDataSource.authorizationStatus == .authorizedAlways {
            localDataSource.requestCurrentLocation()
        }
    }

    func currentCoordinateWithWait() async -> LocationCoordinateEntity? {
        if let coord = localDataSource.currentCoordinate {
            return LocationCoordinateEntity(lat: coord.latitude, lng: coord.longitude)
        }

        for _ in 1...20 {
            switch localDataSource.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                localDataSource.requestCurrentLocation()
            case .denied, .restricted:
                return nil
            case .notDetermined:
                break
            @unknown default:
                return nil
            }

            try? await Task.sleep(nanoseconds: 250_000_000)
            if let coord = localDataSource.currentCoordinate {
                return LocationCoordinateEntity(lat: coord.latitude, lng: coord.longitude)
            }
        }

        return nil
    }

    func locationAccessState() -> LocationAccessState {
        switch localDataSource.authorizationStatus {
        case .notDetermined:
            return .needsPermission
        case .denied, .restricted:
            return .unavailable
        case .authorizedAlways, .authorizedWhenInUse:
            return .available
        @unknown default:
            return .unavailable
        }
    }
}
