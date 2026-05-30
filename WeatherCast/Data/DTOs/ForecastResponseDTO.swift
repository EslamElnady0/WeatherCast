//  ForecastResponseDTO.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import Foundation

struct ForecastResponseDTO: Codable {
    let location: LocationDTO?
    let current: CurrentDTO?
    let forecast: ForecastDTO?
}

struct ForecastDTO: Codable {
    let forecastday: [ForecastDayDTO]?
}

struct ForecastDayDTO: Codable {
    let date: String?
    let day: DayDTO?
    let astro: AstroDTO?
    let hour: [HourDTO]?
}

struct DayDTO: Codable {
    let maxtemp_c: Double?
    let mintemp_c: Double?
    let avgtemp_c: Double?
    let condition: ConditionDTO?
}

struct AstroDTO: Codable {
    let sunrise: String?
    let sunset: String?
}

struct HourDTO: Codable {
    let time: String?
    let time_epoch: Int?
    let temp_c: Double?
    let is_day: Int?
    let condition: ConditionDTO?
}
