//  SavedLocationsEmptyView.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import SwiftUI

struct SavedLocationsEmptyView: View {
    @Environment(LocaleManager.self) private var localeManager

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "bookmark.slash")
                .font(.system(size: 34))
                .foregroundColor(.secondary)
            Text(l10n.savedLocationsEmptyTitle)
                .font(.headline)
            Text(l10n.savedLocationsEmptyBody)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 72)
        .padding(.horizontal)
    }

    private var l10n: L10n {
        L10n(locale: localeManager.locale)
    }
}
