//  HourlyForecastRowView.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 06/06/2026.
//

import SwiftUI

struct HourlyForecastRowView: View {
    let hour: HourEntity
    let viewModel: HourlyForecastViewModel

    @Environment(LocaleManager.self) private var localeManager

    var body: some View {
        HStack(spacing: 20) {
            Text(displayedTime)
                .frame(width: 60, alignment: .leading)
                .font(.title3)
                .fontWeight(.medium)

            AsyncImage(url: URL(string: hour.conditionIconURL)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
            } placeholder: {
                Color.clear.frame(width: 36, height: 36)
            }

            Spacer()

            Text(l10n.celsius(Int(hour.tempC)))
                .font(.title2)
                .bold()
        }
        .foregroundColor(viewModel.theme.foregroundColor)
        .padding(.vertical, 12)
    }

    private var displayedTime: String {
        guard !viewModel.isCurrentHour(hour) else {
            return l10n.now
        }

        return viewModel.formattedTime(
            for: hour,
            locale: localeManager.locale
        )
    }

    private var l10n: L10n {
        L10n(locale: localeManager.locale)
    }
}
