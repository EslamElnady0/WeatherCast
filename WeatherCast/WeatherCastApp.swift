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
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.viewFactory, ViewFactory())
                .environment(\.locale, localeManager.locale)
                .environment(\.layoutDirection, localeManager.isRightToLeft ? .rightToLeft : .leftToRight)
                .environment(localeManager)
        }
        .modelContainer(sharedModelContainer)
    }
}
