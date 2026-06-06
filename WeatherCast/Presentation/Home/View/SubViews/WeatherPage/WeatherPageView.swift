//  WeatherPageView.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import SwiftUI

struct WeatherPageView: View {
    let forecast: ForecastEntity

    @Environment(\.viewFactory) private var viewFactory
    @Environment(LocaleManager.self) private var localeManager

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                HomeWeatherHeaderView(forecast: forecast)
                forecastSection
                bottomSection
            }
            .padding()
        }
        .foregroundColor(theme.foregroundColor)
        .environment(\.weatherTheme, theme)
    }

    private var forecastSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(l10n.forecastTitle)
                .font(.caption).fontWeight(.semibold)
                .opacity(0.6)
                .padding(.bottom, 6)

            Divider().opacity(0.3)

            ForEach(Array(forecast.forecastDays.prefix(3).enumerated()), id: \.offset) { index, day in
                NavigationLink {
                    viewFactory.hourlyForecast(
                        day: day,
                        isDay: forecast.location.isDay
                    )
                } label: {
                    ForecastRowView(day: day, index: index)
                }
                Divider().opacity(0.3)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }

    private var bottomSection: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            WeatherDetailCard(title: l10n.visibility, value: l10n.km(Int(forecast.location.visibilityKm)))
            WeatherDetailCard(title: l10n.humidity, value: l10n.percent(forecast.location.humidity))
            WeatherDetailCard(title: l10n.feelsLike, value: l10n.celsius(Int(forecast.location.feelsLikeC)))
            WeatherDetailCard(title: l10n.pressure, value: l10n.pressureValue(Int(forecast.location.pressureMb)))
        }
    }

    private var l10n: L10n {
        L10n(locale: localeManager.locale)
    }

    private var theme: WeatherTheme {
        WeatherTheme(isDay: forecast.location.isDay)
    }
}
