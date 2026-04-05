//
//  PerformanceTests.swift
//  RunnerWingmanKMPTests
//
//  IMPORTANTE: Adicionar este arquivo ao target RunnerWingmanKMPTests no Xcode.
//  File > New > Target > Unit Testing Bundle (caso o target ainda não exista).
//

import XCTest
import CoreLocation
import Shared

final class DistanceCalculationBenchmark: XCTestCase {

    private var mockLocations: [CLLocation] = []
    private var sharedPoints: [RoutePoint] = []

    override func setUp() {
        super.setUp()
        mockLocations = generateMockRoute(
            pointCount: 1000,
            startLat: -23.5489,
            startLon: -46.6388
        )
        sharedPoints = mockLocations.map { loc in
            RoutePoint(
                latitude: loc.coordinate.latitude,
                longitude: loc.coordinate.longitude,
                timestamp: Int64(loc.timestamp.timeIntervalSince1970 * 1000)
            )
        }
    }

    /// Benchmark: cálculo via shared Kotlin module (RouteCalculations + Haversine)
    func testDistanceCalculation_KMPShared() {
        measure(
            metrics: [
                XCTCPUMetric(),
                XCTMemoryMetric(),
                XCTClockMetric()
            ]
        ) {
            let distance = RouteCalculations.shared.totalDistanceMeters(points: sharedPoints)
            XCTAssertGreaterThan(distance, 0)
        }
    }

    // MARK: - Helpers

    private func generateMockRoute(
        pointCount: Int,
        startLat: Double,
        startLon: Double
    ) -> [CLLocation] {
        var locations: [CLLocation] = []
        var lat = startLat
        var lon = startLon
        let baseDate = Date()

        for i in 0..<pointCount {
            lat += Double.random(in: 0.00001...0.00005)
            lon += Double.random(in: -0.00002...0.00003)

            let location = CLLocation(
                coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                altitude: 760,
                horizontalAccuracy: Double.random(in: 3...15),
                verticalAccuracy: 10,
                timestamp: baseDate.addingTimeInterval(Double(i) * 1.0)
            )
            locations.append(location)
        }
        return locations
    }
}
