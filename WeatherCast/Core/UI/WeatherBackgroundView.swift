//  WeatherBackgroundView.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 06/06/2026.
//

import SwiftUI

struct WeatherBackgroundView<Content: View>: View {
    let theme: WeatherTheme
    private let content: Content

    init(
        theme: WeatherTheme,
        @ViewBuilder content: () -> Content
    ) {
        self.theme = theme
        self.content = content()
    }

    var body: some View {
        ZStack {
            Image(theme.backgroundImage)
                .resizable()
                .ignoresSafeArea()

            content
        }
        .environment(\.weatherTheme, theme)
    }
}
