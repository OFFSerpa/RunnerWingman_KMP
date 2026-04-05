//
//  RouteModel.swift
//  RunnerWingmanKMP
//

import Foundation
import SwiftData
import Shared

@Model
final class RouteModel {
    @Attribute(.unique) var id: UUID
    var name: String
    var distanceMeters: Double
    var bestLapSeconds: Double
    var createdAt: Date

    @Relationship(deleteRule: .cascade)
    var points: [RoutePointModel]

    init(
        id: UUID = UUID(),
        name: String,
        distanceMeters: Double,
        bestLapSeconds: Double,
        createdAt: Date = .now,
        points: [RoutePointModel] = []
    ) {
        self.id = id
        self.name = name
        self.distanceMeters = distanceMeters
        self.bestLapSeconds = bestLapSeconds
        self.createdAt = createdAt
        self.points = points
    }
}

// MARK: - Bridge: Kotlin Route ↔ SwiftData RouteModel

extension RouteModel {
    /// Converte o modelo SwiftData para o modelo Kotlin puro (shared module).
    func toSharedRoute() -> Route {
        return Route(
            id: id.uuidString,
            name: name,
            distanceMeters: distanceMeters,
            bestLapSeconds: bestLapSeconds,
            createdAtTimestamp: Int64(createdAt.timeIntervalSince1970 * 1000),
            points: points.map { $0.toSharedRoutePoint() }
        )
    }
}
