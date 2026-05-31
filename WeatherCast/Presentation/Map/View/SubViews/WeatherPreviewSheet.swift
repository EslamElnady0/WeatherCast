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
        VStack(spacing: 20) {
            switch viewModel.state.previewState {
            case .idle, .loading:
                ProgressView(l10n.loadingWeather)
            case .loaded:
                if let forecast = viewModel.state.previewForecast {
                    forecastContent(forecast)
                }
            case .error(let message):
                Text(message)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }

    @ViewBuilder
    private func forecastContent(_ forecast: ForecastEntity) -> some View {
        VStack(spacing: 8) {
            Text(forecast.location.locationName)
                .font(.title2).bold()
            Text("\(l10n.celsius(Int(forecast.location.tempC)))  ·  \(forecast.location.conditionText)")
                .font(.title3)
            HStack(spacing: 32) {
                Label(l10n.percent(forecast.location.humidity), systemImage: "humidity")
                Label(l10n.km(Int(forecast.location.visibilityKm)), systemImage: "eye")
                Label(l10n.celsius(Int(forecast.location.feelsLikeC)), systemImage: "thermometer")
            }
            .font(.callout)
            .foregroundColor(.secondary)
        }

        Button {
            viewModel.send(.addToFavourites)
        } label: {
            Label(
                viewModel.state.isAlreadySaved ? l10n.alreadySaved : l10n.addToFavourites,
                systemImage: viewModel.state.isAlreadySaved ? "checkmark.circle.fill" : "star.fill"
            )
            .frame(maxWidth: .infinity)
            .padding()
            .background(viewModel.state.isAlreadySaved ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(14)
        }
        .disabled(viewModel.state.isAlreadySaved)
        .padding(.horizontal)
    }

    private var l10n: L10n {
        L10n(locale: localeManager.locale)
    }
}
