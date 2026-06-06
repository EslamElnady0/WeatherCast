//  HourlyForecastView.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import SwiftUI

struct HourlyForecastView: View {
    @State var viewModel: HourlyForecastViewModel
    @State private var summaryHeight: CGFloat = 0
    @State private var showsCompactHeader = false

    @Environment(LocaleManager.self) private var localeManager

    var body: some View {
        WeatherBackgroundView(
            theme: viewModel.theme,
            conditionCode: viewModel.day.conditionCode
        ) {
            ScrollView {
                VStack(spacing: 16) {
                    DailyForecastSummaryView(viewModel: viewModel)
                        .onGeometryChange(for: CGFloat.self) { geometry in
                            geometry.size.height
                        } action: { height in
                            summaryHeight = height
                        }

                    HourlyForecastListView(viewModel: viewModel)
                }
                .padding()
            }
            .onScrollGeometryChange(for: Bool.self) { geometry in
                let scrollOffset = geometry.contentOffset.y
                    + geometry.contentInsets.top
                return scrollOffset > summaryHeight + 16
            } action: { _, isCompact in
                withAnimation(.easeInOut(duration: 0.2)) {
                    showsCompactHeader = isCompact
                }
            }
            .overlay(alignment: .top) {
                if showsCompactHeader {
                    CompactDailyForecastHeaderView(viewModel: viewModel)
                        .padding(.horizontal)
                        .padding(.top, 8)
                        .transition(
                            .move(edge: .top)
                                .combined(with: .opacity)
                        )
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(viewModel.formattedDate(locale: localeManager.locale))
                    .foregroundColor(viewModel.theme.foregroundColor)
            }
        }
    }
}
