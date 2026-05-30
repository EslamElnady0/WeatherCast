//  ForecastDayEntity.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

struct ForecastDayEntity {
    let date: String
    let maxTempC: Double
    let minTempC: Double
    let conditionText: String
    let conditionIconURL: String
    let hours: [HourEntity]
}
