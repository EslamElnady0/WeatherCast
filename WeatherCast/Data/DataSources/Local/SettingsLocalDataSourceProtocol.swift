//  SettingsLocalDataSourceProtocol.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import CoreLocation

protocol SettingsLocalDataSourceProtocol {
    var currentCoordinate: CLLocationCoordinate2D? { get }
    var authorizationStatus: CLAuthorizationStatus { get }
    func requestPermission()
    func requestCurrentLocation()
}
