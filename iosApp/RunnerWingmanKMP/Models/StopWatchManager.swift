//
//  StopWatchManager.swift
//  RunnerWingmanKMP
//
//  Wrapper SwiftUI que encapsula o StopWatch do shared Kotlin module.
//  Mantém a mesma API pública do StopWatchManager original,
//  mas delega a lógica de cronometragem ao Kotlin.
//

import Foundation
import Combine
import Shared

@MainActor
final class StopWatchManager: ObservableObject {

    // MARK: - Properties

    @Published private(set) var elapsed: TimeInterval = 0
    private let stopWatch = StopWatch()
    private var timer: Timer?

    // MARK: - API

    func start() {
        guard timer == nil else { return }
        stopWatch.start()

        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self else { return }
                self.elapsed = self.stopWatch.elapsedSeconds
            }
        }
        RunLoop.main.add(timer!, forMode: .common)
    }

    func stop() {
        guard let timer else { return }
        timer.invalidate()
        self.timer = nil
        stopWatch.stop()
        elapsed = stopWatch.elapsedSeconds
    }

    func reset() {
        stop()
        stopWatch.reset()
        elapsed = 0
    }

    func pause() {
        guard timer != nil else { return }
        stop()
    }

    var formatted: String {
        stopWatch.formatted
    }
}
