//  WeatherDateFormatter.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 06/06/2026.
//

import Foundation

enum WeatherDateFormatter {
    static func forecastDate(
        from value: String,
        locale: Locale
    ) -> String {
        format(
            value,
            inputFormat: "yyyy-MM-dd",
            outputTemplate: "EEEE, MMM d",
            locale: locale
        )
    }

    static func weekday(
        from value: String,
        locale: Locale
    ) -> String {
        format(
            value,
            inputFormat: "yyyy-MM-dd",
            outputTemplate: "EEE",
            locale: locale
        )
    }

    static func hour(
        from value: String,
        locale: Locale
    ) -> String {
        format(
            value,
            inputFormat: "yyyy-MM-dd HH:mm",
            outputTemplate: "ha",
            locale: locale
        )
    }

    static func locationTime(
        from value: String,
        locale: Locale
    ) -> String {
        format(
            value,
            inputFormat: "yyyy-MM-dd HH:mm",
            outputTemplate: "jm",
            locale: locale
        )
    }

    static func astronomyTime(
        from value: String,
        locale: Locale
    ) -> String {
        format(
            value,
            inputFormat: "hh:mm a",
            outputTemplate: "jm",
            locale: locale
        )
    }

    private static func format(
        _ value: String,
        inputFormat: String,
        outputTemplate: String,
        locale: Locale
    ) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        inputFormatter.dateFormat = inputFormat

        guard let date = inputFormatter.date(from: value) else {
            return value
        }

        let outputFormatter = DateFormatter()
        outputFormatter.locale = locale
        outputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        outputFormatter.setLocalizedDateFormatFromTemplate(outputTemplate)
        return outputFormatter.string(from: date)
    }
}
