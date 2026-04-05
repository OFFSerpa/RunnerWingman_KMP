//
//  RecordingMapView.swift
//  RunnerWingmanKMP
//
//  Usa o StopWatchManager (que internamente delega ao StopWatch Kotlin)
//  e o RouteCalculations do shared module para calcular distância.
//

import SwiftUI
import MapKit
import SwiftData
import CoreLocation
import Shared

struct RecordingMapView: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @StateObject private var stopWatch = StopWatchManager()
    @StateObject private var recorder = LocationRecorder()
    @State private var isShowingNameSheet = false
    @State var isRecording: Bool = false
    @State private var routePolyline: MKPolyline?

    // MARK: - Body

    var body: some View {
        ZStack {
            MapComponent(polyline: routePolyline, isFollowingUser: true)
                .safeAreaInset(edge: .bottom) { bottomBar }
        }
        .navigationTitle(navTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color(.systemBackground), for: .navigationBar)
        .onAppear {
            recorder.requestPermission()
        }
        .onChange(of: isRecording) { _, newValue in
            if newValue {
                stopWatch.start()
                recorder.start()
            } else {
                stopWatch.pause()
                recorder.stop()
            }
        }
        .onChange(of: recorder.locations.count) { _, _ in
            updatePolyline()
        }
        .onDisappear {
            recorder.stop()
            stopWatch.stop()
        }
        .sheet(isPresented: $isShowingNameSheet) {
            RouteNameSheet { name in
                saveRoute(
                    name: name,
                    bestLapSeconds: stopWatch.elapsed,
                    locations: recorder.locations
                )
                stopWatch.reset()
                dismiss()
            }
        }
    }

    // MARK: - Components

    private var bottomBar: some View {
        HStack(spacing: 12) {
            ActionButton(
                viewData: .init(
                    title: isRecording ? "Parar" : "Iniciar",
                    color: isRecording ? .orange : .green
                )
            ) {
                isRecording.toggle()
            }

            ActionButton(viewData: .init(title: "Salvar", color: .red)) {
                isRecording = false
                stopWatch.stop()
                recorder.stop()
                isShowingNameSheet = true
            }
            .disabled(recorder.locations.count < 2)
        }
        .padding(.horizontal)
        .padding(.top, 35)
        .padding(.bottom, 10)
        .background(.ultraThinMaterial)
    }

    private var navTitle: String {
        isRecording ? "Gravando Rota \(stopWatch.formatted)" : "Nova Rota"
    }
}

// MARK: - Methods

extension RecordingMapView {
    /// Salva a rota usando RouteCalculations do shared Kotlin para calcular a distância.
    func saveRoute(
        name: String,
        bestLapSeconds: Double,
        locations: [CLLocation]
    ) {
        // --- Usa o shared Kotlin RouteCalculations ---
        let sharedPoints = locations.map { loc in
            RoutePoint(
                latitude: loc.coordinate.latitude,
                longitude: loc.coordinate.longitude,
                timestamp: Int64(loc.timestamp.timeIntervalSince1970 * 1000)
            )
        }
        let distance = BenchmarkLogger.measureDistanceCalculation(
            pointCount: sharedPoints.count
        ) {
            RouteCalculations.shared.totalDistanceMeters(points: sharedPoints)
        }

        // --- Cria os modelos SwiftData ---
        let points = locations.map { loc in
            RoutePointModel(
                latitude: loc.coordinate.latitude,
                longitude: loc.coordinate.longitude,
                timestamp: loc.timestamp
            )
        }

        let route = RouteModel(
            name: name,
            distanceMeters: distance,
            bestLapSeconds: bestLapSeconds,
            points: points
        )

        modelContext.insert(route)

        do {
            try modelContext.save()
            print("Rota salva com sucesso")
        } catch {
            print("Erro ao salvar rota: \(error)")
        }
    }

    private func updatePolyline() {
        let coords = recorder.locations.map { $0.coordinate }

        guard coords.count >= 2 else {
            routePolyline = nil
            return
        }

        routePolyline = MKPolyline(coordinates: coords, count: coords.count)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        RecordingMapView()
    }
    .modelContainer(for: [RouteModel.self, RoutePointModel.self], inMemory: true)
}
