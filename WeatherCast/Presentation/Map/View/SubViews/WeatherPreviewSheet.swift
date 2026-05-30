//  WeatherPreviewSheet.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import SwiftUI

struct WeatherPreviewSheet: View {
    @Bindable var viewModel: MapViewModel

    var body: some View {
        VStack(spacing: 20) {
            switch viewModel.state.previewState {
            case .idle, .loading:
                ProgressView("Loading weather...")
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
            Text("\(Int(forecast.location.tempC))°  ·  \(forecast.location.conditionText)")
                .font(.title3)
            HStack(spacing: 32) {
                Label("\(forecast.location.humidity)%", systemImage: "humidity")
                Label("\(Int(forecast.location.visibilityKm)) km", systemImage: "eye")
                Label("\(Int(forecast.location.feelsLikeC))°", systemImage: "thermometer")
            }
            .font(.callout)
            .foregroundColor(.secondary)
        }

        Button {
            viewModel.send(.addToFavourites)
        } label: {
            Label(
                viewModel.state.isAlreadySaved ? "Already Saved" : "Add to Favourites",
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
}
