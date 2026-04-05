//
//  RunnerWingmanKMPApp.swift
//  RunnerWingmanKMP
//

import SwiftUI
import SwiftData

@main
struct RunnerWingmanKMPApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
            }
            .modelContainer(for: [RouteModel.self, RoutePointModel.self])
        }
    }
}
