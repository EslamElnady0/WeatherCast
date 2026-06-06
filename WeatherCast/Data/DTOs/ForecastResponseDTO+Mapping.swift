//  ForecastResponseDTO+Mapping.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import Foundation

extension ForecastResponseDTO {
    func toDomain() -> ForecastEntity {
        let loc = location
        let cur = current

        let weather = WeatherEntity(
            locationName: loc?.name ?? "",
            localTime: loc?.localtime ?? "",
            lat: loc?.lat ?? 0,
            lng: loc?.lon ?? 0,
            tempC: cur?.temp_c ?? 0,
            feelsLikeC: cur?.feelslike_c ?? 0,
            conditionText: cur?.condition?.text ?? "",
            conditionIconURL: "https:" + (cur?.condition?.icon ?? ""),
            humidity: cur?.humidity ?? 0,
            visibilityKm: cur?.vis_km ?? 0,
            pressureMb: cur?.pressure_mb ?? 0,
            isDay: (cur?.is_day ?? 1) == 1
        )

        let days = forecast?.forecastday?.map { $0.toDomain() } ?? []
        return ForecastEntity(location: weather, forecastDays: days)
    }
}

extension ForecastDayDTO {
    func toDomain() -> ForecastDayEntity {
        ForecastDayEntity(
            date: date ?? "",
            maxTempC: day?.maxtemp_c ?? 0,
            minTempC: day?.mintemp_c ?? 0,
            averageTempC: day?.avgtemp_c ?? 0,
            conditionText: day?.condition?.text ?? "",
            conditionIconURL: "https:" + (day?.condition?.icon ?? ""),
            sunrise: astro?.sunrise ?? "",
            sunset: astro?.sunset ?? "",
            hours: hour?.map { $0.toDomain() } ?? []
        )
    }
}

extension HourDTO {
    func toDomain() -> HourEntity {
        HourEntity(
            timeEpoch: time_epoch ?? 0,
            time: time ?? "",
            tempC: temp_c ?? 0,
            conditionIconURL: "https:" + (condition?.icon ?? ""),
            isDay: (is_day ?? 1) == 1
        )
    }
}

extension SearchResultDTO {
    func toDomain() -> SearchResultEntity {
        SearchResultEntity(
            id: id ?? 0,
            name: name ?? "",
            region: region ?? "",
            country: country ?? "",
            lat: lat ?? 0,
            lng: lon ?? 0
        )
    }
}
