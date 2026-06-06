//  CitySearchFailureView.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 06/06/2026.
//

import SwiftUI

struct CitySearchFailureView: View {
    let message: String

    @Environment(LocaleManager.self) private var localeManager

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "exclamationmark.magnifyingglass")
                .font(.title3)
                .foregroundStyle(.red)

            VStack(alignment: .leading, spacing: 4) {
                Text(l10n.citySearchFailureTitle)
                    .font(.headline)

                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(14)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.12), radius: 8, y: 4)
        .accessibilityElement(children: .combine)
    }

    private var l10n: L10n {
        L10n(locale: localeManager.locale)
    }
}
