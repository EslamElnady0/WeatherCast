//  CoreAssembly.swift
//  WeatherCast
//
//  Created by Eslam Elnady on 30/05/2026.
//

import Swinject

final class CoreAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LocaleManager.self) { _ in
            LocaleManager()
        }
        .inObjectScope(.container)

        container.register(LocationManagerProtocol.self) { _ in
            LocationManager()
        }
        .inObjectScope(.container)
    }
}
