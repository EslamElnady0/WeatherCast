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

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.largeTitle)
            Text(title)
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .opacity(0.8)
        }
        .padding()
    }
}
