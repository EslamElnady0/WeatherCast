//  AppContainer.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import SwiftData
import Swinject

final class AppContainer {
    static let shared = AppContainer()

    let container = Container()
    private var assembler: Assembler?

    private init() {}

    func build(modelContext: ModelContext) {
        assembler = Assembler(
            [
                CoreAssembly(),
                NetworkAssembly(),
                DataAssembly(modelContext: modelContext),
                DomainAssembly(),
                PresentationAssembly()
            ],
            container: container
        )
    }

    func resolve<T>(_ type: T.Type) -> T {
        guard let value = container.resolve(type) else {
            fatalError("Swinject: \(type) is not registered.")
        }
        return value
    }

    func resolve<T, Argument>(_ type: T.Type, argument: Argument) -> T {
        guard let value = container.resolve(type, argument: argument) else {
            fatalError("Swinject: \(type) is not registered for \(Argument.self).")
        }
        return value
    }
}
