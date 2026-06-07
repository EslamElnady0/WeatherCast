//  SavedLocationCardView.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import SwiftUI

struct SavedLocationCardView: View {
    let row: SavedLocationRow
    let onSelect: () -> Void

    @Environment(LocaleManager.self) private var localeManager
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 14) {
                weatherIcon

                locationDetails

                Spacer(minLength: 8)

                if let temperature = row.forecast?.location.tempC {
                    Text(l10n.celsius(Int(temperature)))
                        .font(.system(size: 32, weight: .light, design: .rounded))
                        .foregroundColor(.primary)
                }

                Image(systemName: "chevron.forward")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .padding(8)
                    .background(
                        Color.primary.opacity(0.06),
                        in: Circle()
                    )
            }
            .contentShape(Rectangle())
            .padding(16)
            .frame(minHeight: 88)
            .background(cardBackground)
            .clipShape(cardShape)
            .overlay {
                cardShape
                    .stroke(borderColor, lineWidth: 1)
            }
            .shadow(
                color: .black.opacity(colorScheme == .light ? 0.14 : 0.28),
                radius: 12,
                y: 6
            )
        }
        .buttonStyle(SavedLocationCardButtonStyle())
        .disabled(row.forecast == nil)
    }

    private var weatherIcon: some View {
        ZStack {
            Circle()
                .fill(Color.blue.opacity(colorScheme == .light ? 0.10 : 0.18))

            AsyncImage(url: URL(string: row.forecast?.location.conditionIconURL ?? "")) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Image(systemName: "cloud.sun.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.blue)
            }
            .padding(4)
        }
        .frame(width: 58, height: 58)
    }

    private var locationDetails: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(row.location.name)
                .font(.headline)
                .foregroundColor(.primary)

            Text(row.forecast?.location.conditionText ?? l10n.savedLocationsWeatherUnavailable)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1)

            if let today = row.forecast?.forecastDays.first {
                Text(l10n.highLow(high: Int(today.maxTempC), low: Int(today.minTempC)))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }

    private var l10n: L10n {
        L10n(locale: localeManager.locale)
    }

    private var cardShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
    }

    private var cardBackground: some View {
        ZStack {
            cardShape
                .fill(.regularMaterial)

            cardShape
                .fill(
                    colorScheme == .light
                        ? Color.white.opacity(0.62)
                        : Color.white.opacity(0.08)
                )
        }
    }

    private var borderColor: Color {
        colorScheme == .light
            ? Color.white.opacity(0.95)
            : Color.white.opacity(0.18)
    }
}

private struct SavedLocationCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.985 : 1)
            .opacity(configuration.isPressed ? 0.88 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
