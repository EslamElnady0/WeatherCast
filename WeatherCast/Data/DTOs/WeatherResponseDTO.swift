//  WeatherResponseDTO.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import Foundation

struct WeatherResponseDTO: Codable {
    let location: LocationDTO?
    let current: CurrentDTO?
}

struct LocationDTO: Codable {
    let name: String?
    let region: String?
    let country: String?
    let lat: Double?
    let lon: Double?
    let localtime: String?
}

struct CurrentDTO: Codable {
    let temp_c: Double?
    let temp_f: Double?
    let is_day: Int?
    let condition: ConditionDTO?
    let wind_kph: Double?
    let pressure_mb: Double?
    let humidity: Int?
    let feelslike_c: Double?
    let vis_km: Double?
}

struct ConditionDTO: Codable {
    let text: String?
    let icon: String?
    let code: Int?
}
