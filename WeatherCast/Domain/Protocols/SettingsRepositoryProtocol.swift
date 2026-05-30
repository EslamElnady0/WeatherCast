//  SettingsRepositoryProtocol.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

enum LocationAccessState {
    case needsPermission
    case unavailable
    case available
}

protocol SettingsRepositoryProtocol {
    func requestLocationIfNeeded()
    func currentCoordinateWithWait() async -> LocationCoordinateEntity?
    func locationAccessState() -> LocationAccessState
}
