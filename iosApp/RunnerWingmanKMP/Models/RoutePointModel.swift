//
//  RoutePointModel.swift
//  RunnerWingmanKMP
//

import Foundation
import SwiftData
import Shared

@Model
final class RoutePointModel {
    var latitude: Double
    var longitude: Double
    var timestamp: Date

    init(latitude: Double, longitude: Double, timestamp: Date = .now) {
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
    }
}

// MARK: - Bridge: Kotlin RoutePoint ↔ SwiftData RoutePointModel

extension RoutePointModel {
    /// Converte para o modelo Kotlin puro (shared module).
    func toSharedRoutePoint() -> RoutePoint {
        return RoutePoint(
            latitude: latitude,
            longitude: longitude,
            timestamp: Int64(timestamp.timeIntervalSince1970 * 1000)
        )
    }
}
