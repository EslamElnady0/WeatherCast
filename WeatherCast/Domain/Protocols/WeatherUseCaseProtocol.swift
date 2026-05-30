//  WeatherUseCaseProtocol.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

protocol WeatherUseCaseProtocol {
    associatedtype Input
    associatedtype Output

    func execute(_ input: Input) async throws -> Output
}
