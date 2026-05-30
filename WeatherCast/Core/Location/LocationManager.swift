//  LocationManager.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import CoreLocation
import Observation

@Observable
final class LocationManager: NSObject, LocationManagerProtocol, CLLocationManagerDelegate {
    private(set) var currentCoordinate: CLLocationCoordinate2D? = nil
    private(set) var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    private let clManager = CLLocationManager()
    
    override init() {
        super.init()
        clManager.delegate = self
        clManager.desiredAccuracy = kCLLocationAccuracyKilometer
        authorizationStatus = clManager.authorizationStatus
    }
    
    func requestPermission() {
        clManager.requestWhenInUseAuthorization()
    }
    
    func requestCurrentLocation() {
        clManager.requestLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            requestCurrentLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentCoordinate = locations.last?.coordinate
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}
