//
//  RouteRepository.swift
//  RunnerWingmanKMP
//

import SwiftData
import Foundation

@MainActor
final class RouteRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func rename(_ route: RouteModel, to newName: String) throws {
        let trimmed = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        route.name = trimmed
        try context.save()
    }

    func delete(_ route: RouteModel) throws {
        context.delete(route)
        try context.save()
    }
}
