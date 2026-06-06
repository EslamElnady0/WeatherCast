//  DailyForecastSummaryView.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 06/06/2026.
//

import SwiftUI

struct DailyForecastSummaryView: View {
    let viewModel: HourlyForecastViewModel

    @Environment(LocaleManager.self) private var localeManager

    var body: some View {
        VStack(spacing: 14) {
            HStack(spacing: 16) {
                AsyncImage(url: URL(string: viewModel.day.conditionIconURL)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 72, height: 72)
                } placeholder: {
                    ProgressView()
                        .frame(width: 72, height: 72)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.day.conditionText)
                        .font(.title3)
                        .fontWeight(.semibold)

                    Text(l10n.averageTemperature)
                        .font(.caption)
                        .opacity(0.7)

                    Text(l10n.celsius(Int(viewModel.day.averageTempC)))
                        .font(.system(size: 42, weight: .light))

                    Text(
                        l10n.highLow(
                            high: Int(viewModel.day.maxTempC),
                            low: Int(viewModel.day.minTempC)
                        )
                    )
                    .font(.callout)
                }

                Spacer()
            }

            Divider().opacity(0.3)

            HStack(spacing: 12) {
                summaryValue(
                    title: l10n.sunrise,
                    systemImage: "sunrise.fill",
                    value: viewModel.formattedAstronomyTime(
                        viewModel.day.sunrise,
                        locale: localeManager.locale
                    )
                )
                .frame(maxWidth: .infinity)

                summaryValue(
                    title: l10n.sunset,
                    systemImage: "sunset.fill",
                    value: viewModel.formattedAstronomyTime(
                        viewModel.day.sunset,
                        locale: localeManager.locale
                    )
                )
                .frame(maxWidth: .infinity)
            }
        }
        .foregroundColor(viewModel.theme.foregroundColor)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func summaryValue(
        title: String,
        systemImage: String,
        value: String
    ) -> some View {
        VStack(spacing: 5) {
            Image(systemName: systemImage)
                .font(.title3)

            Text(title)
                .font(.caption2)
                .opacity(0.7)

            Text(value)
                .font(.callout)
                .fontWeight(.semibold)
        }
    }

    private var l10n: L10n {
        L10n(locale: localeManager.locale)
    }
}
