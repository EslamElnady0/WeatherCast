//  RequestParameters.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import Foundation

protocol RequestParameters {
    func toDict() -> [String: Any]
}

struct WeatherByCoordParams: RequestParameters {
    let lat: Double
    let lng: Double
    let days: Int
    let lang: String
    let aqi: String
    let alerts: String

    func toDict() -> [String: Any] {
        [
            "q": "\(lat),\(lng)",
            "days": days,
            "lang": lang,
            "aqi": aqi,
            "alerts": alerts
        ]
    }
}

struct SearchParams: RequestParameters {
    let query: String

    func toDict() -> [String: Any] {
        ["q": query]
    }
}
