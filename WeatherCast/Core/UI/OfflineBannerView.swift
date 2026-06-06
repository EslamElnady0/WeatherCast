//  OfflineBannerView.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 06/06/2026.
//

import SwiftUI

struct OfflineBannerView: View {
    @Environment(LocaleManager.self) private var localeManager

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "wifi.slash")
                .font(.headline)

            Text(l10n.offlineMessage)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(2)

            Spacer(minLength: 0)
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 9)
        .background(
            Color.red.opacity(0.92),
            in: RoundedRectangle(cornerRadius: 14)
        )
        .shadow(color: .black.opacity(0.18), radius: 8, y: 4)
        .padding(.horizontal)
        .padding(.top, 6)
        .padding(.bottom, 4)
        .accessibilityElement(children: .combine)
    }

    private var l10n: L10n {
        L10n(locale: localeManager.locale)
    }
}
