//  AppSecrets.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import Foundation

enum AppSecrets {
    static var weatherAPIKey: String? {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "WEATHER_API_KEY") as? String else {
            return nil
        }
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, trimmed != "YOUR_API_KEY_HERE" else {
            return nil
        }
        return trimmed
    }
}
