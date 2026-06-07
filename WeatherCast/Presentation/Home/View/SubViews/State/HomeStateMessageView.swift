//  HomeStateMessageView.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import SwiftUI

struct HomeStateMessageView: View {
    let systemImage: String
    let title: String
    let message: String
    let retryTitle: String
    let onRetry: () -> Void

    @Environment(\.weatherTheme) private var theme

    var body: some View {
        VStack {
            VStack(spacing: 24) {
                stateSymbol

                VStack(spacing: 10) {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(message)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(theme.foregroundColor.opacity(0.75))
                        .fixedSize(horizontal: false, vertical: true)
                }

                Button(action: onRetry) {
                    Label(retryTitle, systemImage: "arrow.clockwise")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 50)
                }
                .buttonStyle(RetryButtonStyle(theme: theme))
            }
            .foregroundStyle(theme.foregroundColor)
            .padding(.horizontal, 24)
            .padding(.vertical, 30)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(theme.foregroundColor.opacity(0.14), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.18), radius: 24, y: 12)
            .frame(maxWidth: 420)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 20)
        .padding(.vertical, 32)
    }

    private var stateSymbol: some View {
        ZStack {
            Circle()
                .fill(theme.foregroundColor.opacity(0.12))

            Circle()
                .stroke(theme.foregroundColor.opacity(0.18), lineWidth: 1)

            Image(systemName: systemImage)
                .font(.system(size: 38, weight: .semibold))
                .symbolRenderingMode(.hierarchical)
        }
        .frame(width: 88, height: 88)
        .accessibilityHidden(true)
    }
}

private struct RetryButtonStyle: ButtonStyle {
    let theme: WeatherTheme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(foregroundColor)
            .background(
                theme.foregroundColor.opacity(
                    configuration.isPressed ? 0.78 : 0.92
                ),
                in: RoundedRectangle(cornerRadius: 15, style: .continuous)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }

    private var foregroundColor: Color {
        switch theme {
        case .morning:
            return .white
        case .evening:
            return .black
        }
    }
}
