//  WeatherBackgroundView.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 06/06/2026.
//

import SwiftUI

struct WeatherBackgroundView<Content: View>: View {
    let theme: WeatherTheme
    let conditionCode: Int
    private let content: Content

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(
        theme: WeatherTheme,
        conditionCode: Int,
        @ViewBuilder content: () -> Content
    ) {
        self.theme = theme
        self.conditionCode = conditionCode
        self.content = content()
    }

    var body: some View {
        ZStack {
            fallbackImage

            if !reduceMotion {
                LoopingVideoView(
                    resourceName: weatherCondition.videoName(for: theme)
                )
                .ignoresSafeArea()
            }

            content
        }
        .environment(\.weatherTheme, theme)
    }

    private var fallbackImage: some View {
        Image(theme.backgroundImage)
            .resizable()
            .ignoresSafeArea()
    }

    private var weatherCondition: WeatherConditionVisual {
        WeatherConditionVisual(code: conditionCode)
    }
}

private enum WeatherConditionVisual {
    case clear
    case cloudy
    case fog
    case rain
    case snow
    case thunder

    init(code: Int) {
        switch code {
        case 1000:
            self = .clear
        case 1003, 1006, 1009:
            self = .cloudy
        case 1030, 1135, 1147:
            self = .fog
        case 1087, 1273, 1276, 1279, 1282:
            self = .thunder
        case 1066, 1069, 1072, 1114, 1117,
             1204, 1207, 1210, 1213, 1216, 1219,
             1222, 1225, 1237, 1249, 1252, 1255,
             1258, 1261, 1264:
            self = .snow
        case 1063, 1150, 1153, 1168, 1171,
             1180, 1183, 1186, 1189, 1192, 1195,
             1198, 1201, 1240, 1243, 1246:
            self = .rain
        default:
            self = .cloudy
        }
    }

    func videoName(for theme: WeatherTheme) -> String {
        switch (self, theme) {
        case (.clear, .morning):
            return "weather_clear_day"
        case (.clear, .evening):
            return "weather_clear_night"
        case (.cloudy, .morning):
            return "weather_cloudy_day"
        case (.cloudy, .evening):
            return "weather_cloudy_night"
        case (.fog, .morning):
            return "weather_fog_day"
        case (.fog, .evening):
            return "weather_fog_night"
        case (.rain, .morning):
            return "weather_rain_day"
        case (.rain, .evening):
            return "weather_rain_night"
        case (.snow, .morning):
            return "weather_snow_day"
        case (.snow, .evening):
            return "weather_snow_night"
        case (.thunder, _):
            return "weather_thunder"
        }
    }
}
