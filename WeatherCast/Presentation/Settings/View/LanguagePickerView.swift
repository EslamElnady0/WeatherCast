//  LanguagePickerView.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import SwiftUI

struct LanguagePickerView: View {
    @Environment(LocaleManager.self) private var localeManager
    @State private var pendingLanguage: LocaleManager.AppLanguage?

    var body: some View {
        List(LocaleManager.AppLanguage.allCases) { language in
            Button {
                guard language != localeManager.currentLanguage else { return }
                pendingLanguage = language
            } label: {
                HStack {
                    Text(language.displayName)
                    Spacer()
                    if localeManager.currentLanguage == language {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .navigationTitle(l10n.languageTitle)
        .navigationBarTitleDisplayMode(.inline)
        .alert(l10n.languageRestartTitle, isPresented: restartAlertBinding) {
            Button(l10n.cancel, role: .cancel) {
                pendingLanguage = nil
            }
            Button(l10n.apply) {
                guard let pendingLanguage else { return }
                localeManager.setLanguage(pendingLanguage)
                self.pendingLanguage = nil
            }
        } message: {
            Text(l10n.languageRestartBody)
        }
    }

    private var l10n: L10n {
        L10n(locale: localeManager.locale)
    }

    private var restartAlertBinding: Binding<Bool> {
        Binding(
            get: { pendingLanguage != nil },
            set: { isPresented in
                if !isPresented {
                    pendingLanguage = nil
                }
            }
        )
    }
}
