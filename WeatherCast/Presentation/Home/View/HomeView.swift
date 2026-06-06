//  HomeView.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import SwiftUI

struct HomeView: View {
    @State var viewModel: HomeViewModel
    @Environment(\.viewFactory) private var viewFactory
    @Environment(LocaleManager.self) private var localeManager
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        WeatherBackgroundView(
            theme: theme,
            conditionCode: currentConditionCode
        ) {
            switch viewModel.state {
            case .idle, .loading:
                ProgressView()
                    .tint(theme.foregroundColor)
            case .needsLocationPermission:
                NoLocationView(
                    title: l10n.locationPermissionTitle,
                    message: l10n.locationPermissionBody,
                    primaryAction: .requestPermission(viewModel.requestLocationPermission)
                )
            case .locationUnavailable:
                NoLocationView(
                    title: l10n.locationUnavailableTitle,
                    message: l10n.locationUnavailableBody,
                    primaryAction: .openSettings
                )
            case .empty:
                HomeStateMessageView(
                    systemImage: "cloud",
                    title: l10n.emptyWeatherTitle,
                    message: l10n.emptyWeatherBody
                )
            case .error(let message):
                HomeStateMessageView(
                    systemImage: "exclamationmark.triangle",
                    title: l10n.weatherUnavailableTitle,
                    message: message
                )
            case .loaded:
                forecastPager
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .task {
            await viewModel.loadAll()
        }
        .onChange(of: scenePhase) { _, newPhase in
            guard newPhase == .active else { return }
            Task { await viewModel.loadAll() }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    LanguagePickerView()
                } label: {
                    Image(systemName: "globe")
                }
            }

            if case .loaded = viewModel.state {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        viewFactory.savedLocations(
                            onSelect: viewModel.selectLocation,
                            onLocationsChanged: {
                                Task { await viewModel.loadAll() }
                            }
                        )
                    } label: {
                        Image(systemName: "list.bullet")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        viewFactory.map(
                            onLocationSaved: {
                                Task { await viewModel.loadAll() }
                            }
                        )
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }

    private var l10n: L10n {
        L10n(locale: localeManager.locale)
    }

    private var theme: WeatherTheme {
        guard viewModel.forecasts.indices.contains(viewModel.currentPageIndex) else {
            return .current
        }

        return WeatherTheme(
            isDay: viewModel.forecasts[viewModel.currentPageIndex].location.isDay
        )
    }

    private var currentConditionCode: Int {
        guard viewModel.forecasts.indices.contains(viewModel.currentPageIndex) else {
            return 1000
        }

        return viewModel.forecasts[viewModel.currentPageIndex]
            .location
            .conditionCode
    }

    private var forecastPager: some View {
        TabView(selection: $viewModel.currentPageIndex) {
            ForEach(
                Array(viewModel.forecasts.enumerated()),
                id: \.offset
            ) { index, forecast in
                WeatherPageView(forecast: forecast)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
}
