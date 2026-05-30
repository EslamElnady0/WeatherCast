//  HourlyForecastView.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import SwiftUI

struct HourlyForecastView: View {
    let day: ForecastDayEntity
    @Environment(\.weatherTheme) private var theme
    
    private var hours: [HourEntity] {
        let now = Int(Date().timeIntervalSince1970)
        return day.hours.filter { $0.timeEpoch >= now }
    }

    var body: some View {
        ZStack {
            Image(theme.backgroundImage)
                .resizable()
                .ignoresSafeArea()

            List {
                ForEach(Array(hours.enumerated()), id: \.element.timeEpoch) { index, hour in
                    HStack(spacing: 20) {
                        Text(formattedTime(from: hour.timeEpoch, isFirst: index == 0))
                            .frame(width: 55, alignment: .leading)
                            .font(.title3).fontWeight(.medium)

                        AsyncImage(url: URL(string: hour.conditionIconURL)) { image in
                            image.resizable().scaledToFit().frame(width: 36, height: 36)
                        } placeholder: {
                            Color.clear.frame(width: 36, height: 36)
                        }

                        Spacer()

                        Text("\(Int(hour.tempC))°")
                            .font(.title2).bold()
                    }
                    .foregroundColor(theme.foregroundColor)
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(day.date)
                    .foregroundColor(theme.foregroundColor)
            }
        }
    }

    private func formattedTime(from epoch: Int, isFirst: Bool) -> String {
        if isFirst { return "Now" }
        let date = Date(timeIntervalSince1970: TimeInterval(epoch))
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        return formatter.string(from: date)
    }
}
