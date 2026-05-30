//  SearchResultDTO.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import Foundation

struct SearchResultDTO: Codable {
    let id: Int?
    let name: String?
    let region: String?
    let country: String?
    let lat: Double?
    let lon: Double?
    let url: String?
}
