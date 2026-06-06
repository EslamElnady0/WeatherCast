//  HomeWeatherHeaderView.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 06/06/2026.
//

import SwiftUI

struct HomeWeatherHeaderView: View {
    let forecast: ForecastEntity

    @Environment(LocaleManager.self) private var localeManager
    @Environment(\.weatherTheme) private var theme

    var body: some View {
        HStack(spacing: 18) {
            weatherIcon

            VStack(alignment: .leading, spacing: 7) {
                locationDetails

                Text(l10n.celsius(Int(forecast.location.tempC)))
                    .font(.system(size: 62, weight: .thin))
                    .minimumScaleFactor(0.75)
                    .lineLimit(1)

                Text(forecast.location.conditionText)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .lineLimit(2)

                if let today = forecast.forecastDays.first {
                    Text(
                        l10n.highLow(
                            high: Int(today.maxTempC),
                            low: Int(today.minTempC)
                        )
                    )
                    .font(.callout)
                    .fontWeight(.medium)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .foregroundColor(theme.foregroundColor)
        .padding(18)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay {
            RoundedRectangle(cornerRadius: 24)
                .stroke(.white.opacity(0.16), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.12), radius: 14, y: 7)
    }

    private var weatherIcon: some View {
        AsyncImage(url: URL(string: forecast.location.conditionIconURL)) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
        }
        .frame(width: 120, height: 120)
        
    }

    private var locationDetails: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(forecast.location.locationName)
                .font(.title2)
                .fontWeight(.bold)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            if !forecast.location.localTime.isEmpty {
                Label(
                    WeatherDateFormatter.locationTime(
                        from: forecast.location.localTime,
                        locale: localeManager.locale
                    ),
                    systemImage: "clock"
                )
                .font(.caption)
                .opacity(0.75)
            }
        }
    }

    private var l10n: L10n {
        L10n(locale: localeManager.locale)
    }
}
