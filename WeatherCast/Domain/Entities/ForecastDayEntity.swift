//  ForecastDayEntity.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

struct ForecastDayEntity {
    let date: String
    let maxTempC: Double
    let minTempC: Double
    let averageTempC: Double
    let conditionText: String
    let conditionIconURL: String
    let conditionCode: Int
    let sunrise: String
    let sunset: String
    let hours: [HourEntity]
}
