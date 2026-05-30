//  RootView.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import SwiftData
import SwiftUI

struct RootView: View {
    @State private var viewModel: HomeViewModel
    private let mapUseCase: MapUseCaseProtocol

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
        let mapUseCase = MapUseCase(
            weatherRepository: repository,
            settingsRepository: settingsRepository
        )
        let homeViewModel = HomeViewModel(homeUseCase: homeUseCase)

        _viewModel = State(wrappedValue: homeViewModel)
        self.mapUseCase = mapUseCase
    }

    var body: some View {
        NavigationStack {
            HomeView(
                viewModel: viewModel,
                mapUseCase: mapUseCase
            )
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
