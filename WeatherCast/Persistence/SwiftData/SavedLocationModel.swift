//  SavedLocationModel.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import Foundation
import SwiftData

@Model
final class SavedLocationModel {
    var id: UUID = UUID()
    var name: String = ""
    var lat: Double = 0.0
    var lng: Double = 0.0
    var sortOrder: Int = 0

    init(name: String, lat: Double, lng: Double, sortOrder: Int = 0) {
        self.name = name
        self.lat = lat
        self.lng = lng
        self.sortOrder = sortOrder
    }
}
