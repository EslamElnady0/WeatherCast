//  L10n.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import Foundation

struct L10n {
    let locale: Locale

    var today: String { localized("home.today") }
    var tomorrow: String { localized("home.tomorrow") }
    var forecastTitle: String { localized("home.forecast.title") }
    var visibility: String { localized("home.visibility") }
    var humidity: String { localized("home.humidity") }
    var feelsLike: String { localized("home.feelsLike") }
    var pressure: String { localized("home.pressure") }
    var now: String { localized("hourly.now") }
    var averageTemperature: String { localized("hourly.average") }
    var sunrise: String { localized("hourly.sunrise") }
    var sunset: String { localized("hourly.sunset") }
    var mapTitle: String { localized("map.title") }
    var selectedLocation: String { localized("map.selectedLocation") }
    var searchPlaceholder: String { localized("map.searchPlaceholder") }
    var addToFavourites: String { localized("map.addToFav") }
    var alreadySaved: String { localized("map.alreadySaved") }
    var loadingWeather: String { localized("map.loading") }
    var locationPermissionTitle: String { localized("location.permission.title") }
    var locationPermissionBody: String { localized("location.permission.body") }
    var locationUnavailableTitle: String { localized("location.unavailable.title") }
    var locationUnavailableBody: String { localized("location.unavailable.body") }
    var emptyWeatherTitle: String { localized("home.empty.title") }
    var emptyWeatherBody: String { localized("home.empty.body") }
    var weatherUnavailableTitle: String { localized("home.error.title") }
    var savedLocationsTitle: String { localized("savedLocations.title") }
    var savedLocationsEmptyTitle: String { localized("savedLocations.empty.title") }
    var savedLocationsEmptyBody: String { localized("savedLocations.empty.body") }
    var savedLocationsWeatherUnavailable: String { localized("savedLocations.weatherUnavailable") }
    var savedLocationsDeleteTitle: String { localized("savedLocations.delete.title") }
    var savedLocationsDeleteErrorTitle: String { localized("savedLocations.delete.error.title") }
    var enableLocation: String { localized("location.enable") }
    var openSettings: String { localized("location.settings") }
    var languageTitle: String { localized("settings.language") }
    var languageRestartTitle: String { localized("settings.language.restart.title") }
    var languageRestartBody: String { localized("settings.language.restart.body") }
    var cancel: String { localized("common.cancel") }
    var apply: String { localized("common.apply") }
    var delete: String { localized("common.delete") }
    var ok: String { localized("common.ok") }

    func km(_ value: Int) -> String {
        formatted("unit.km", number(value))
    }

    func percent(_ value: Int) -> String {
        formatted("unit.percent", number(value))
    }

    func celsius(_ value: Int) -> String {
        formatted("unit.celsius", number(value))
    }

    func pressureValue(_ value: Int) -> String {
        number(value)
    }

    func temperatureRange(min: Int, max: Int) -> String {
        formatted("unit.temperatureRange", celsius(min), celsius(max))
    }

    func highLow(high: Int, low: Int) -> String {
        formatted("home.highLow", celsius(high), celsius(low))
    }

    func savedLocationsDeleteBody(_ locationName: String) -> String {
        formatted("savedLocations.delete.body", locationName)
    }

    private func localized(_ key: String.LocalizationValue) -> String {
        String(localized: key, bundle: languageBundle, locale: locale)
    }

    private func formatted(_ key: String.LocalizationValue, _ arguments: CVarArg...) -> String {
        String(format: localized(key), locale: locale, arguments: arguments)
    }

    private func number(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.locale = locale
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }

    private var languageBundle: Bundle {
        guard let languageCode = locale.language.languageCode?.identifier,
              let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return .main
        }

        return bundle
    }
}
