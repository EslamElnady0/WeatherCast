//  MapView.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import MapKit
import SwiftUI

struct MapView: View {
    @State var viewModel: MapViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(LocaleManager.self) private var localeManager
    @State private var cameraPosition: MapCameraPosition = .region(Self.fallbackRegion)

    var body: some View {
        ZStack(alignment: .top) {
            MapReader { proxy in
                Map(position: $cameraPosition) {
                    if let coordinate = viewModel.state.selectedCoordinate {
                        Marker(l10n.selectedLocation, coordinate: coordinate)
                    }
                }
                .ignoresSafeArea(edges: .bottom)
                .simultaneousGesture(
                    SpatialTapGesture()
                        .onEnded { value in
                            guard let coordinate = proxy.convert(value.location, from: .local) else {
                                return
                            }
                            viewModel.send(.mapTapped(coordinate))
                        }
                )
            }

            VStack(spacing: 0) {
                searchBar

                if !viewModel.state.searchResults.isEmpty {
                    searchResultsList
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
        .sheet(isPresented: sheetPresentationBinding) {
            WeatherPreviewSheet(viewModel: viewModel)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .navigationTitle(l10n.mapTitle)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.send(.loadInitialPosition)
        }
        .onChange(of: viewModel.state.cameraUpdateID) { _, _ in
            guard let region = viewModel.state.requestedRegion else { return }
            cameraPosition = .region(region)
        }
        .onChange(of: viewModel.state.shouldDismiss) { _, shouldDismiss in
            guard shouldDismiss else { return }
            viewModel.send(.dismissHandled)
            dismiss()
        }
    }

    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField(l10n.searchPlaceholder, text: searchQueryBinding)
                .autocorrectionDisabled()

            if viewModel.state.isSearching {
                ProgressView()
                    .padding(.trailing, 4)
            }
        }
        .padding(10)
        .background(.regularMaterial)
        .cornerRadius(12)
    }

    private var searchResultsList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(viewModel.state.searchResults, id: \.id) { result in
                    Button {
                        viewModel.send(.searchResultSelected(result))
                    } label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(result.name)
                                .font(.body)
                            Text("\(result.region), \(result.country)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .buttonStyle(.plain)

                    Divider()
                }
            }
        }
        .frame(maxHeight: 220)
        .background(.regularMaterial)
        .cornerRadius(12)
    }

    private var searchQueryBinding: Binding<String> {
        Binding(
            get: { viewModel.state.searchQuery },
            set: { viewModel.send(.searchQueryChanged($0)) }
        )
    }

    private var sheetPresentationBinding: Binding<Bool> {
        Binding(
            get: { viewModel.state.isSheetPresented },
            set: { viewModel.send(.sheetPresentationChanged($0)) }
        )
    }

    private var l10n: L10n {
        L10n(locale: localeManager.locale)
    }

    private static let fallbackRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 30.05, longitude: 31.25),
        latitudinalMeters: 500_000,
        longitudinalMeters: 500_000
    )
}
