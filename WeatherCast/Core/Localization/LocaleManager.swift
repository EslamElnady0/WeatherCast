//  LocaleManager.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import Foundation
import Observation

@Observable
final class LocaleManager {
    enum AppLanguage: String, CaseIterable, Identifiable {
        case english = "en"
        case arabic = "ar"

        var id: String { rawValue }

        var displayName: String {
            switch self {
            case .english:
                return "English"
            case .arabic:
                return "العربية"
            }
        }
    }

    private(set) var currentLanguage: AppLanguage
    private(set) var rootID = UUID()
    private let defaults: UserDefaults

    var locale: Locale {
        Locale(identifier: currentLanguage.rawValue)
    }

    var apiLanguage: String {
        currentLanguage.rawValue
    }

    var isRightToLeft: Bool {
        currentLanguage == .arabic
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        if let savedLanguage = defaults.string(forKey: Self.languageKey),
           let language = AppLanguage(rawValue: savedLanguage) {
            currentLanguage = language
        } else {
            let languageCode = Locale.current.language.languageCode?.identifier
            currentLanguage = languageCode == AppLanguage.arabic.rawValue ? .arabic : .english
        }
    }

    func setLanguage(_ language: AppLanguage) {
        guard language != currentLanguage else { return }

        currentLanguage = language
        defaults.set(language.rawValue, forKey: Self.languageKey)
        defaults.synchronize()
        rootID = UUID()
    }

    private static let languageKey = "app_language"
}
