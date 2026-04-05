//
//  LocationRecorder.swift
//  RunnerWingmanKMP
//

import CoreLocation
import Combine
import os

@MainActor
final class LocationRecorder: NSObject, ObservableObject, CLLocationManagerDelegate {

    @Published private(set) var locations: [CLLocation] = []

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.activityType = .fitness
        manager.distanceFilter = 3
    }

    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    func start() {
        locations.removeAll()
        BenchmarkLogger.beginGPSFirstFix()
        manager.startUpdatingLocation()
    }

    func stop() {
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations newLocations: [CLLocation]) {
        let valid = newLocations.filter { loc in
            loc.horizontalAccuracy >= 0 &&
            loc.horizontalAccuracy <= 20 &&
            loc.speed >= 0
        }

        guard !valid.isEmpty else { return }

        if locations.isEmpty {
            BenchmarkLogger.endGPSFirstFix()
            locations.append(valid[0])
        }

        for loc in valid {
            guard let last = locations.last else { break }

            let distance = loc.distance(from: last)
            if distance >= 4 {
                locations.append(loc)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("[LocationRecorder] GPS error: \(error.localizedDescription)")
    }
}
