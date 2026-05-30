//  WeatherPageView.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import SwiftUI

struct WeatherPageView: View {
    let forecast: ForecastEntity
    @Environment(\.weatherTheme) private var theme

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                topSection
                forecastSection
                bottomSection
            }
            .padding()
        }
        .foregroundColor(theme.foregroundColor)
    }

    private var topSection: some View {
        VStack(spacing: 4) {
            Text(forecast.location.locationName)
                .font(.title).bold()

            Text("\(Int(forecast.location.tempC))°")
                .font(.system(size: 80, weight: .thin))

            Text(forecast.location.conditionText)
                .font(.title3)

            if let today = forecast.forecastDays.first {
                Text("H:\(Int(today.maxTempC))°  L:\(Int(today.minTempC))°")
                    .font(.callout)
            }

            AsyncImage(url: URL(string: forecast.location.conditionIconURL)) { image in
                image.resizable().scaledToFit().frame(width: 64, height: 64)
            } placeholder: {
                ProgressView()
            }
        }
    }

    private var forecastSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("3-DAY FORECAST")
                .font(.caption).fontWeight(.semibold)
                .opacity(0.6)
                .padding(.bottom, 6)

            Divider().opacity(0.3)

            ForEach(Array(forecast.forecastDays.prefix(3).enumerated()), id: \.offset) { index, day in
                NavigationLink(destination: HourlyForecastView(day: day)) {
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
            WeatherDetailCard(title: "VISIBILITY", value: "\(Int(forecast.location.visibilityKm)) km")
            WeatherDetailCard(title: "HUMIDITY", value: "\(forecast.location.humidity)%")
            WeatherDetailCard(title: "FEELS LIKE", value: "\(Int(forecast.location.feelsLikeC))°")
            WeatherDetailCard(title: "PRESSURE", value: "\(Int(forecast.location.pressureMb))")
        }
    }
}
