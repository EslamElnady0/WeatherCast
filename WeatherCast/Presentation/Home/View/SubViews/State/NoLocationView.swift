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
    @Environment(\.weatherTheme) private var theme

    enum PrimaryAction {
        case requestPermission(() -> Void)
        case openSettings
    }

    var body: some View {
        VStack {
            VStack(spacing: 24) {
                locationIllustration

                VStack(spacing: 10) {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(message)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(theme.foregroundColor.opacity(0.75))
                        .fixedSize(horizontal: false, vertical: true)
                }

                VStack(spacing: 10) {
                    primaryButton

                    if case .requestPermission = primaryAction {
                        settingsButton(isPrimary: false)
                    }
                }
            }
            .foregroundStyle(theme.foregroundColor)
            .padding(.horizontal, 24)
            .padding(.vertical, 30)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(theme.foregroundColor.opacity(0.14), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.18), radius: 24, y: 12)
            .frame(maxWidth: 420)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 20)
        .padding(.vertical, 32)
    }

    private var locationIllustration: some View {
        Image("no_location_illustration")
            .resizable()
            .scaledToFit()
            .frame(width: 156, height: 156)
            .accessibilityHidden(true)
    }

    @ViewBuilder
    private var primaryButton: some View {
        switch primaryAction {
        case .requestPermission(let action):
            Button(action: action) {
                actionLabel(
                    l10n.enableLocation,
                    systemImage: "location.fill"
                )
            }
            .buttonStyle(PrimaryLocationButtonStyle(theme: theme))
        case .openSettings:
            settingsButton(isPrimary: true)
        }
    }

    @ViewBuilder
    private func settingsButton(isPrimary: Bool) -> some View {
        if isPrimary {
            Link(destination: settingsURL) {
                actionLabel(l10n.openSettings, systemImage: "gearshape.fill")
            }
            .buttonStyle(PrimaryLocationButtonStyle(theme: theme))
        } else {
            Link(destination: settingsURL) {
                actionLabel(l10n.openSettings, systemImage: "gearshape.fill")
            }
            .buttonStyle(SecondaryLocationButtonStyle(theme: theme))
        }
    }

    private func actionLabel(
        _ title: String,
        systemImage: String
    ) -> some View {
        Label(title, systemImage: systemImage)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 50)
    }

    private var settingsURL: URL {
        URL(string: UIApplication.openSettingsURLString)!
    }

    private var l10n: L10n {
        L10n(locale: localeManager.locale)
    }
}

private struct PrimaryLocationButtonStyle: ButtonStyle {
    let theme: WeatherTheme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(primaryForegroundColor)
            .background(
                theme.foregroundColor.opacity(
                    configuration.isPressed ? 0.78 : 0.92
                ),
                in: RoundedRectangle(cornerRadius: 15, style: .continuous)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }

    private var primaryForegroundColor: Color {
        switch theme {
        case .morning:
            return .white
        case .evening:
            return .black
        }
    }
}

private struct SecondaryLocationButtonStyle: ButtonStyle {
    let theme: WeatherTheme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(theme.foregroundColor)
            .background(
                theme.foregroundColor.opacity(
                    configuration.isPressed ? 0.16 : 0.08
                ),
                in: RoundedRectangle(cornerRadius: 15, style: .continuous)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .stroke(theme.foregroundColor.opacity(0.16), lineWidth: 1)
            }
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
