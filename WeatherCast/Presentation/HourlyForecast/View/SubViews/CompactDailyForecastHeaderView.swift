//  CompactDailyForecastHeaderView.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 06/06/2026.
//

import SwiftUI

struct CompactDailyForecastHeaderView: View {
    let viewModel: HourlyForecastViewModel

    @Environment(LocaleManager.self) private var localeManager

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: viewModel.day.conditionIconURL)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
            } placeholder: {
                ProgressView()
                    .frame(width: 44, height: 44)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.day.conditionText)
                    .font(.headline)
                    .lineLimit(1)

                Text(viewModel.formattedDate(locale: localeManager.locale))
                    .font(.caption)
                    .opacity(0.7)
                    .lineLimit(1)
            }

            Spacer()

            Text(l10n.celsius(Int(viewModel.day.averageTempC)))
                .font(.title2)
                .fontWeight(.semibold)
        }
        .foregroundColor(viewModel.theme.foregroundColor)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
    }

    private var l10n: L10n {
        L10n(locale: localeManager.locale)
    }
}
