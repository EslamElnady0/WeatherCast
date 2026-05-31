//  LanguagePickerView.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import SwiftUI

struct LanguagePickerView: View {
    @Environment(LocaleManager.self) private var localeManager

    var body: some View {
        List(LocaleManager.AppLanguage.allCases) { language in
            Button {
                localeManager.setLanguage(language)
            } label: {
                HStack {
                    Text(language.displayName)
                    Spacer()
                    if localeManager.currentLanguage == language {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
            }
            .buttonStyle(.plain)
        }
        .navigationTitle(l10n.languageTitle)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var l10n: L10n {
        L10n(locale: localeManager.locale)
    }
}
