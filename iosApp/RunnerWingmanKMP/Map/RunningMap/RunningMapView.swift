//
//  RunningMapView.swift
//  RunnerWingmanKMP
//
//  Usa o StopWatchManager (shared Kotlin) e TimeFormattersHelper (shared Kotlin)
//  para cronometragem e formatação de tempo.
//

import SwiftUI
import MapKit
import SwiftData
import CoreLocation
import Shared

struct RunningMapView: View {

    // MARK: - Properties

    @Environment(\.modelContext) private var modelContext

    let route: RouteModel

    @StateObject private var stopWatch = StopWatchManager()
    @StateObject private var recorder = LocationRecorder()

    @State private var isRunning: Bool = false
    @State private var polyline: MKPolyline?

    @State private var didFinish: Bool = false
    @State private var finishRadiusMeters: Double = 20

    // MARK: - Body

    var body: some View {
        ZStack {
            MapComponent(polyline: polyline, isFollowingUser: true)
                .safeAreaInset(edge: .bottom) { bottomBar }
        }
        .navigationTitle(navTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color(.systemBackground), for: .navigationBar)
        .onAppear {
            recorder.requestPermission()
            buildPolyline()
        }
        .onChange(of: isRunning) { _, newValue in
            if newValue {
                didFinish = false
                stopWatch.reset()
                stopWatch.start()
                recorder.start()
            } else {
                stopWatch.stop()
                recorder.stop()
            }
        }
        .onChange(of: recorder.locations.count) { _, _ in
            checkFinishIfNeeded()
        }
        .onDisappear {
            recorder.stop()
            stopWatch.stop()
        }
        .alert("Chegou ao fim da rota", isPresented: $didFinish) {
            Button("OK") { }
        } message: {
            if stopWatch.elapsed < route.bestLapSeconds {
                Text("Novo recorde: \(TimeFormattersHelper.mmss(stopWatch.elapsed))")
            } else {
                Text("Tempo: \(TimeFormattersHelper.mmss(stopWatch.elapsed))")
            }
        }
    }

    // MARK: - Components

    private var bottomBar: some View {
        HStack(spacing: 12) {
            ActionButton(
                viewData: .init(
                    title: isRunning ? "Parar" : "Iniciar",
                    color: isRunning ? .orange : .green
                )
            ) {
                isRunning.toggle()
            }

            ActionButton(
                viewData: .init(
                    title: "Reset",
                    color: .gray
                )
            ) {
                isRunning = false
                didFinish = false
                stopWatch.reset()
            }
        }
        .padding(.horizontal)
        .padding(.top, 35)
        .padding(.bottom, 10)
        .background(.ultraThinMaterial)
    }

    private var navTitle: String {
        isRunning ? "Correndo \(stopWatch.formatted)" : route.name
    }

    // MARK: - Methods

    private func buildPolyline() {
        let coords = route.points.map {
            CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
        }
        guard coords.count >= 2 else { return }
        polyline = MKPolyline(coordinates: coords, count: coords.count)
    }

    private func checkFinishIfNeeded() {
        guard isRunning, !didFinish else { return }
        guard let lastLocation = recorder.locations.last else { return }

        guard let finishCoord = finishCoordinate else { return }

        let finishLocation = CLLocation(latitude: finishCoord.latitude, longitude: finishCoord.longitude)
        let distanceToFinish = lastLocation.distance(from: finishLocation)

        if distanceToFinish <= finishRadiusMeters {
            didFinish = true
            isRunning = false
            updateBestLapIfNeeded()
        }
    }

    private var finishCoordinate: CLLocationCoordinate2D? {
        guard let lastPoint = route.points.last else { return nil }
        return CLLocationCoordinate2D(latitude: lastPoint.latitude, longitude: lastPoint.longitude)
    }

    private func updateBestLapIfNeeded() {
        let newTime = stopWatch.elapsed
        guard newTime > 0 else { return }

        if route.bestLapSeconds == 0 || newTime < route.bestLapSeconds {
            route.bestLapSeconds = newTime
            do {
                try modelContext.save()
            } catch {
                print("Erro ao salvar novo recorde: \(error)")
            }
        }
    }
}
