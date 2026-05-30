//  HomeView.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import SwiftUI

struct HomeView: View {
    @Bindable var viewModel: HomeViewModel
    @Environment(\.weatherTheme) private var theme

    var body: some View {
        ZStack {
            Image(theme.backgroundImage)
                .resizable()
                .ignoresSafeArea()

            switch viewModel.state {
            case .idle, .loading:
                ProgressView()
                    .tint(theme.foregroundColor)
            case .needsLocationPermission:
                NoLocationView(
                    title: "Location permission needed",
                    message: "Allow location access to show weather for your current city."
                )
            case .locationUnavailable:
                NoLocationView(
                    title: "Location unavailable",
                    message: "Choose a simulator location or add a saved city."
                )
            case .empty:
                HomeStateMessageView(
                    systemImage: "cloud",
                    title: "No weather yet",
                    message: "Add a saved city or allow location access to load a forecast."
                )
            case .error(let message):
                HomeStateMessageView(
                    systemImage: "exclamationmark.triangle",
                    title: "Weather unavailable",
                    message: message
                )
            case .loaded:
                forecastPager
            }
        }
        .task {
            await viewModel.loadAll()
        }
    }

    private var forecastPager: some View {
        TabView(selection: $viewModel.currentPageIndex) {
            ForEach(viewModel.forecasts.indices, id: \.self) { index in
                WeatherPageView(forecast: viewModel.forecasts[index])
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
}
