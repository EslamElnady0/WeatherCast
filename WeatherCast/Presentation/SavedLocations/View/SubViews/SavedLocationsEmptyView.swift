//  SavedLocationsEmptyView.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import SwiftUI

struct SavedLocationsEmptyView: View {
    @Environment(LocaleManager.self) private var localeManager

    var body: some View {
        VStack {
            VStack(spacing: 22) {
                Image("saved_locations_empty_illustration")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 164, height: 164)
                    .accessibilityHidden(true)

                VStack(spacing: 10) {
                    Text(l10n.savedLocationsEmptyTitle)
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(l10n.savedLocationsEmptyBody)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 30)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(.primary.opacity(0.08), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.12), radius: 20, y: 10)
            .frame(maxWidth: 420)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 20)
        .padding(.vertical, 32)
    }

    private var l10n: L10n {
        L10n(locale: localeManager.locale)
    }
}
