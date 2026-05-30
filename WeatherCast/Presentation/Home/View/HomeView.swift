//  HomeView.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import SwiftUI

struct HomeView: View {
    @Bindable var viewModel: HomeViewModel
    let mapUseCase: MapUseCaseProtocol
    @Environment(\.weatherTheme) private var theme
    @Environment(\.scenePhase) private var scenePhase

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
                    message: "Allow location access to show weather for your current city.",
                    primaryAction: .requestPermission(viewModel.requestLocationPermission)
                )
            case .locationUnavailable:
                NoLocationView(
                    title: "Location unavailable",
                    message: "Enable location access in Settings or add a saved city.",
                    primaryAction: .openSettings
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
        .onChange(of: scenePhase) { _, newPhase in
            guard newPhase == .active else { return }
            Task { await viewModel.loadAll() }
        }
        .toolbar {
            if case .loaded = viewModel.state {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        MapView(
                            viewModel: MapViewModel(
                                mapUseCase: mapUseCase,
                                onLocationSaved: {
                                    Task { await viewModel.loadAll() }
                                }
                            )
                        )
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
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
