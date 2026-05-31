//  NoLocationView.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import SwiftUI

struct NoLocationView: View {
    let title: String
    let message: String
    let primaryAction: PrimaryAction
    @Environment(LocaleManager.self) private var localeManager

    enum PrimaryAction {
        case requestPermission(() -> Void)
        case openSettings
    }

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "location.slash.fill")
                .font(.system(size: 64))
                .foregroundColor(.gray)
            Text(title)
                .font(.title2).bold()
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)

            switch primaryAction {
            case .requestPermission(let action):
                Button(action: action) {
                    Label(l10n.enableLocation, systemImage: "location.fill")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            case .openSettings:
                Link(destination: settingsURL) {
                    Label(l10n.openSettings, systemImage: "gear")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }

            if case .requestPermission = primaryAction {
                Link(l10n.openSettings, destination: settingsURL)
                    .foregroundColor(.blue)
            }
        }
        .padding(32)
    }

    private var settingsURL: URL {
        URL(string: UIApplication.openSettingsURLString)!
    }

    private var l10n: L10n {
        L10n(locale: localeManager.locale)
    }
}
