//  HourlyForecastViewModel.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 06/06/2026.
//

import Foundation
import Observation

@Observable
final class HourlyForecastViewModel {
    let day: ForecastDayEntity
    let theme: WeatherTheme

    init(day: ForecastDayEntity, isDay: Bool) {
        self.day = day
        theme = WeatherTheme(isDay: isDay)
    }

    func displayedHours(now: Date = Date()) -> [HourEntity] {
        let currentEpoch = Int(now.timeIntervalSince1970)
        return day.hours.filter { $0.timeEpoch + 3_600 > currentEpoch }
    }

    func isCurrentHour(_ hour: HourEntity, now: Date = Date()) -> Bool {
        let currentEpoch = Int(now.timeIntervalSince1970)
        return currentEpoch >= hour.timeEpoch && currentEpoch < hour.timeEpoch + 3_600
    }

    func formattedDate(locale: Locale) -> String {
        WeatherDateFormatter.forecastDate(
            from: day.date,
            locale: locale
        )
    }

    func formattedTime(for hour: HourEntity, locale: Locale) -> String {
        WeatherDateFormatter.hour(
            from: hour.time,
            locale: locale
        )
    }

    func formattedAstronomyTime(_ value: String, locale: Locale) -> String {
        WeatherDateFormatter.astronomyTime(
            from: value,
            locale: locale
        )
    }
}
