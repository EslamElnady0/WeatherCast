//  RootView.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import SwiftData
import SwiftUI

struct RootView: View {
    @State private var viewModel: HomeViewModel

    init(context: ModelContext) {
        let remote = WeatherRemoteDataSource(client: .shared)
        let local = WeatherLocalDataSource(context: context)
        let repository = WeatherRepositoryImpl(remote: remote, local: local, network: .shared)
        let locationManager = LocationManager()
        let settingsLocalDataSource = SettingsLocalDataSource(locationManager: locationManager)
        let settingsRepository = SettingsRepositoryImpl(localDataSource: settingsLocalDataSource)
        let homeUseCase = HomeUseCase(
            weatherRepository: repository,
            settingsRepository: settingsRepository
        )

        _viewModel = State(
            wrappedValue: HomeViewModel(
                homeUseCase: homeUseCase
            )
        )
    }

    var body: some View {
        NavigationStack {
            HomeView(viewModel: viewModel)
        }
    }
}

//#Preview {
//    let schema = Schema([
//        SavedLocationModel.self,
//        CachedWeatherModel.self
//    ])
//    let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
//    let container = try! ModelContainer(for: schema, configurations: [configuration])
//
//    return RootView(context: container.mainContext)
//        .modelContainer(container)
//}
