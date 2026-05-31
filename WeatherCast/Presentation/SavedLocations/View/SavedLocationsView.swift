//  SavedLocationsView.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import SwiftUI

struct SavedLocationsView: View {
    @State private var viewModel: SavedLocationsViewModel
    let onSelect: (LocationCoordinateEntity) -> Void

    @Environment(\.dismiss) private var dismiss
    @Environment(LocaleManager.self) private var localeManager

    init(
        viewModel: SavedLocationsViewModel,
        onSelect: @escaping (LocationCoordinateEntity) -> Void
    ) {
        _viewModel = State(wrappedValue: viewModel)
        self.onSelect = onSelect
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                switch viewModel.state {
                case .idle, .loading:
                    ProgressView()
                        .controlSize(.large)
                        .padding(.vertical, 72)
                case .empty:
                    SavedLocationsEmptyView()
                case .loaded:
                    ForEach(viewModel.rows) { row in
                        SavedLocationCardView(row: row) {
                            select(row)
                        }
                    }
                }
            }
            .padding()
        }
        .background(background)
        .navigationTitle(l10n.savedLocationsTitle)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.load()
        }
    }

    private func select(_ row: SavedLocationRow) {
        guard row.forecast != nil else { return }
        onSelect(
            LocationCoordinateEntity(
                lat: row.location.lat,
                lng: row.location.lng
            )
        )
        dismiss()
    }

    private var background: some View {
        LinearGradient(
            colors: [
                Color.blue.opacity(0.10),
                Color.cyan.opacity(0.04),
                Color.clear
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    private var l10n: L10n {
        L10n(locale: localeManager.locale)
    }
}
