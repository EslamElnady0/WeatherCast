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
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.viewFactory, ViewFactory())
        }
        .modelContainer(sharedModelContainer)
    }
}
