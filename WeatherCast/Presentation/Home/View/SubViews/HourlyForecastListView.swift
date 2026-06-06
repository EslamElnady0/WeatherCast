//  HourlyForecastListView.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 06/06/2026.
//

import SwiftUI

struct HourlyForecastListView: View {
    let viewModel: HourlyForecastViewModel

    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(viewModel.displayedHours(), id: \.timeEpoch) { hour in
                HourlyForecastRowView(
                    hour: hour,
                    viewModel: viewModel
                )

                Divider().opacity(0.3)
            }
        }
        .padding(.horizontal)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
