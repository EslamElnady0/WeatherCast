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

    private var label: String {
        switch index {
        case 0:
            return "Today"
        case 1:
            return "Tomorrow"
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

            Text("\(Int(day.minTempC))° – \(Int(day.maxTempC))°")
        }
        .font(.callout)
        .foregroundColor(theme.foregroundColor)
        .padding(.vertical, 10)
    }

    private func dayName(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else { return dateString }
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}
