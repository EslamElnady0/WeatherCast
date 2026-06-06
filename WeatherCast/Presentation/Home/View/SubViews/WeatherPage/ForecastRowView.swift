//  ForecastRowView.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import SwiftUI

struct ForecastRowView: View {
    let day: ForecastDayEntity
    let index: Int
    @Environment(\.weatherTheme) private var theme
    @Environment(LocaleManager.self) private var localeManager

    private var label: String {
        switch index {
        case 0:
            return l10n.today
        case 1:
            return l10n.tomorrow
        default:
            return dayName(from: day.date)
        }
    }

    var body: some View {
        HStack {
            Text(label).frame(width: 90, alignment: .leading)

            AsyncImage(url: URL(string: day.conditionIconURL)) { image in
                image.resizable().scaledToFit().frame(width: 28, height: 28)
            } placeholder: {
                Color.clear.frame(width: 28, height: 28)
            }

            Spacer()

            Text(l10n.temperatureRange(min: Int(day.minTempC), max: Int(day.maxTempC)))
        }
        .font(.callout)
        .foregroundColor(theme.foregroundColor)
        .padding(.vertical, 10)
    }

    private func dayName(from dateString: String) -> String {
        WeatherDateFormatter.weekday(
            from: dateString,
            locale: localeManager.locale
        )
    }

    private var l10n: L10n {
        L10n(locale: localeManager.locale)
    }
}
