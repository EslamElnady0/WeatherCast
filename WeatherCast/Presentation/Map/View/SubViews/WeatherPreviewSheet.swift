//  WeatherPreviewSheet.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import SwiftUI

struct WeatherPreviewSheet: View {
    @Bindable var viewModel: MapViewModel
    @Environment(LocaleManager.self) private var localeManager

    var body: some View {
        VStack(spacing: 16) {
            switch viewModel.state.previewState {
            case .idle, .loading:
                loadingContent
            case .loaded:
                if let forecast = viewModel.state.previewForecast {
                    forecastContent(forecast)
                }
            case .error(let message):
                errorContent(message)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 18)
        .padding(.bottom, 14)
    }

    @ViewBuilder
    private func forecastContent(_ forecast: ForecastEntity) -> some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 5) {
                Text(forecast.location.locationName)
                    .font(.title2).bold()
                    .lineLimit(1)
                Text(forecast.location.conditionText)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text(l10n.celsius(Int(forecast.location.tempC)))
                .font(.system(size: 42, weight: .light, design: .rounded))
        }

        HStack(spacing: 8) {
            metricTile(
                value: l10n.percent(forecast.location.humidity),
                systemImage: "humidity"
            )
            metricTile(
                value: l10n.km(Int(forecast.location.visibilityKm)),
                systemImage: "eye"
            )
            metricTile(
                value: l10n.celsius(Int(forecast.location.feelsLikeC)),
                systemImage: "thermometer"
            )
        }

        Button {
            viewModel.send(.addToFavourites)
        } label: {
            Label(
                viewModel.state.isAlreadySaved ? l10n.alreadySaved : l10n.addToFavourites,
                systemImage: viewModel.state.isAlreadySaved ? "checkmark.circle.fill" : "star.fill"
            )
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .background(viewModel.state.isAlreadySaved ? Color.gray.opacity(0.75) : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(16)
        }
        .disabled(viewModel.state.isAlreadySaved)
    }

    private var loadingContent: some View {
        VStack(spacing: 12) {
            ProgressView()
                .controlSize(.large)
            Text(l10n.loadingWeather)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorContent(_ message: String) -> some View {
        VStack(spacing: 10) {
            Image(systemName: "cloud.bolt")
                .font(.largeTitle)
                .foregroundColor(.orange)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func metricTile(value: String, systemImage: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: systemImage)
                .font(.callout)
                .foregroundColor(.blue)
            Text(value)
                .font(.caption).fontWeight(.semibold)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color.primary.opacity(0.06))
        .cornerRadius(12)
    }

    private var l10n: L10n {
        L10n(locale: localeManager.locale)
    }
}
