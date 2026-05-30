//  SettingsLocalDataSource.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import CoreLocation

final class SettingsLocalDataSource: SettingsLocalDataSourceProtocol {
    private let locationManager: LocationManagerProtocol

    init(locationManager: LocationManagerProtocol) {
        self.locationManager = locationManager
    }

    var currentCoordinate: CLLocationCoordinate2D? {
        locationManager.currentCoordinate
    }

    var authorizationStatus: CLAuthorizationStatus {
        locationManager.authorizationStatus
    }

    func requestPermission() {
        locationManager.requestPermission()
    }

    func requestCurrentLocation() {
        locationManager.requestCurrentLocation()
    }
}
