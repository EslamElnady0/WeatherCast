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
                    .font(.caption).fontWeight(.semibold)
                    .foregroundColor(.secondary)
            }
            .contentShape(Rectangle())
            .padding(14)
            .background(.regularMaterial)
            .cornerRadius(18)
        }
        .buttonStyle(.plain)
        .disabled(row.forecast == nil)
    }

    private var weatherIcon: some View {
        AsyncImage(url: URL(string: row.forecast?.location.conditionIconURL ?? "")) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            Image(systemName: "cloud.sun")
                .foregroundColor(.secondary)
        }
        .frame(width: 52, height: 52)
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
}
