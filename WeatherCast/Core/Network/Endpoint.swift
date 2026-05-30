//  Endpoint.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: RequestParameters? { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

extension Endpoint {
    var baseURL: String { "https://api.weatherapi.com/v1" }
    var fullURL: String { "\(baseURL)/\(path)" }
}

enum WeatherEndpoint: Endpoint {
    case forecast(params: WeatherByCoordParams)
    case currentWeather(params: WeatherByCoordParams)
    case search(params: SearchParams)

    var path: String {
        switch self {
        case .forecast:
            return "forecast.json"
        case .currentWeather:
            return "current.json"
        case .search:
            return "search.json"
        }
    }

    var method: HTTPMethod { .get }

    var parameters: RequestParameters? {
        switch self {
        case .forecast(let params):
            return params
        case .currentWeather(let params):
            return params
        case .search(let params):
            return params
        }
    }
}
