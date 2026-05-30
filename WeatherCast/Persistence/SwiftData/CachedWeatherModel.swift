//  CachedWeatherModel.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import Foundation
import SwiftData

@Model
final class CachedWeatherModel {
    var locationKey: String = ""
    var jsonData: Data = Data()
    var cachedAt: Date = Date()

    init(locationKey: String, jsonData: Data) {
        self.locationKey = locationKey
        self.jsonData = jsonData
        self.cachedAt = Date()
    }
}
