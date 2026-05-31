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
