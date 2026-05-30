//  WeatherTheme.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import SwiftUI

enum WeatherTheme {
    case morning
    case evening

    static var current: WeatherTheme {
        let hour = Calendar.current.component(.hour, from: Date())
        return (hour >= 5 && hour < 18) ? .morning : .evening
    }

    var backgroundImage: String {
        switch self {
        case .morning:
            return "morning_bg"
        case .evening:
            return "evening_bg"
        }
    }

    var foregroundColor: Color {
        switch self {
        case .morning:
            return .black
        case .evening:
            return .white
        }
    }
}

private struct WeatherThemeKey: EnvironmentKey {
    static let defaultValue: WeatherTheme = .current
}

extension EnvironmentValues {
    var weatherTheme: WeatherTheme {
        get { self[WeatherThemeKey.self] }
        set { self[WeatherThemeKey.self] = newValue }
    }
}
