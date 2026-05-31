//  RootView.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import SwiftUI

struct RootView: View {
    @Environment(\.viewFactory) private var viewFactory

    var body: some View {
        NavigationStack {
            viewFactory.home()
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
