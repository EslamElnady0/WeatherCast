//
//  WeatherCastApp.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import SwiftUI
import SwiftData

@main
struct WeatherCastApp: App {
    @State private var localeManager: LocaleManager
    @State private var connectivityMonitor: InternetConnectivityMonitor

    let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            SavedLocationModel.self,
            CachedWeatherModel.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    init() {
        AppContainer.shared.build(modelContext: sharedModelContainer.mainContext)
        _localeManager = State(
            wrappedValue: AppContainer.shared.resolve(LocaleManager.self)
        )
        _connectivityMonitor = State(
            wrappedValue: AppContainer.shared.resolve(
                InternetConnectivityMonitor.self
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                RootView()
                    .id(localeManager.rootID)
                    .transition(.opacity)
                    .safeAreaInset(edge: .bottom, spacing: 0) {
                        if !connectivityMonitor.isConnected {
                            OfflineBannerView()
                                .transition(
                                    .move(edge: .bottom)
                                        .combined(with: .opacity)
                                )
                        }
                    }
                    .environment(\.viewFactory, ViewFactory())
                    .environment(\.locale, localeManager.locale)
                    .environment(\.layoutDirection, localeManager.isRightToLeft ? .rightToLeft : .leftToRight)
                    .environment(localeManager)
            }
            .animation(.easeInOut(duration: 0.3), value: localeManager.rootID)
            .animation(
                .easeInOut(duration: 0.25),
                value: connectivityMonitor.isConnected
            )
        }
        .modelContainer(sharedModelContainer)
    }
}
