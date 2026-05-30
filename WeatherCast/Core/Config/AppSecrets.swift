//  AppSecrets.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import Foundation

enum AppSecrets {
    static var weatherAPIKey: String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "WEATHER_API_KEY") as? String,
              !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              value != "YOUR_API_KEY_HERE"
        else {
            fatalError("Missing WEATHER_API_KEY. Set it in Secrets.xcconfig.")
        }
        return value
    }
}
