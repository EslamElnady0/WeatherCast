//  WeatherEntity.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

struct WeatherEntity {
    let locationName: String
    let localTime: String
    let lat: Double
    let lng: Double
    let tempC: Double
    let feelsLikeC: Double
    let conditionText: String
    let conditionIconURL: String
    let conditionCode: Int
    let humidity: Int
    let visibilityKm: Double
    let pressureMb: Double
    let isDay: Bool
}
