//  WeatherDetailCard.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import SwiftUI

struct WeatherDetailCard: View {
    let title: String
    let value: String
    @Environment(\.weatherTheme) private var theme

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption2).fontWeight(.semibold)
                .opacity(0.6)
            Text(value)
                .font(.title2).bold()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .foregroundColor(theme.foregroundColor)
    }
}
