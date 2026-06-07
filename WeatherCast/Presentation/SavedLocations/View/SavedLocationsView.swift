//  SavedLocationsView.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import SwiftUI

struct SavedLocationsView: View {
    @State private var viewModel: SavedLocationsViewModel
    @State private var pendingDeletion: SavedLocationRow?
    @State private var isMapPresented = false
    let onSelect: (LocationCoordinateEntity) -> Void
    let onLocationsChanged: () -> Void

    @Environment(\.dismiss) private var dismiss
    @Environment(\.viewFactory) private var viewFactory
    @Environment(LocaleManager.self) private var localeManager

    init(
        viewModel: SavedLocationsViewModel,
        onSelect: @escaping (LocationCoordinateEntity) -> Void,
        onLocationsChanged: @escaping () -> Void
    ) {
        _viewModel = State(wrappedValue: viewModel)
        self.onSelect = onSelect
        self.onLocationsChanged = onLocationsChanged
    }

    var body: some View {
        ZStack {
            background
            content
        }
        .navigationTitle(l10n.savedLocationsTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isMapPresented = true
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel(l10n.mapTitle)
            }
        }
        .sheet(isPresented: $isMapPresented) {
            NavigationStack {
                viewFactory.map(onLocationSaved: locationSaved)
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(28)
        }
        .task {
            await viewModel.load()
        }
        .alert(
            l10n.savedLocationsDeleteTitle,
            isPresented: deletionConfirmationBinding,
            presenting: pendingDeletion
        ) { row in
            Button(l10n.delete, role: .destructive) {
                remove(row)
            }
            Button(l10n.cancel, role: .cancel) {}
        } message: { row in
            Text(l10n.savedLocationsDeleteBody(row.location.name))
        }
        .alert(
            l10n.savedLocationsDeleteErrorTitle,
            isPresented: deletionErrorBinding
        ) {
            Button(l10n.ok, role: .cancel) {
                viewModel.clearDeletionError()
            }
        } message: {
            Text(viewModel.deletionErrorMessage ?? "")
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView()
                .controlSize(.large)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .empty:
            SavedLocationsEmptyView()
        case .loaded:
            locationsList
        }
    }

    private var locationsList: some View {
        List {
            ForEach(viewModel.rows) { row in
                SavedLocationCardView(row: row) {
                    select(row)
                }
                .listRowInsets(
                    EdgeInsets(
                        top: 6,
                        leading: 16,
                        bottom: 6,
                        trailing: 16
                    )
                )
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .swipeActions {
                    Button(role: .destructive) {
                        pendingDeletion = row
                    } label: {
                        Label(l10n.delete, systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
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

    private func remove(_ row: SavedLocationRow) {
        guard viewModel.remove(row) else { return }
        onLocationsChanged()
    }

    private func locationSaved() {
        onLocationsChanged()
        Task {
            await viewModel.load()
        }
    }

    private var deletionConfirmationBinding: Binding<Bool> {
        Binding(
            get: { pendingDeletion != nil },
            set: { isPresented in
                if !isPresented {
                    pendingDeletion = nil
                }
            }
        )
    }

    private var deletionErrorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.deletionErrorMessage != nil },
            set: { isPresented in
                if !isPresented {
                    viewModel.clearDeletionError()
                }
            }
        )
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
