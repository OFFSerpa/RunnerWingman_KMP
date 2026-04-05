//
//  BenchmarkLogger.swift
//  RunnerWingmanKMP
//

import os

enum BenchmarkLogger {

    private static let subsystem = "com.wingman.benchmark"

    static let gps         = OSLog(subsystem: subsystem, category: "GPS")
    static let calculation = OSLog(subsystem: subsystem, category: "Calculation")
    static let ui          = OSLog(subsystem: subsystem, category: "UI")
    static let memory      = OSLog(subsystem: subsystem, category: "Memory")

    // MARK: GPS First Fix

    static let gpsFirstFix = OSSignpostID(log: gps)

    static func beginGPSFirstFix() {
        os_signpost(
            .begin,
            log: gps,
            name: "GPS First Fix",
            signpostID: gpsFirstFix
        )
    }

    static func endGPSFirstFix() {
        os_signpost(
            .end,
            log: gps,
            name: "GPS First Fix",
            signpostID: gpsFirstFix
        )
    }

    // MARK: Distance Calculation

    static func measureDistanceCalculation(
        pointCount: Int,
        block: () -> Double
    ) -> Double {
        let id = OSSignpostID(log: calculation)
        os_signpost(
            .begin,
            log: calculation,
            name: "Distance Calculation",
            signpostID: id,
            "points: %d", pointCount
        )
        let result = block()
        os_signpost(
            .end,
            log: calculation,
            name: "Distance Calculation",
            signpostID: id,
            "distance: %.2f", result
        )
        return result
    }
}
