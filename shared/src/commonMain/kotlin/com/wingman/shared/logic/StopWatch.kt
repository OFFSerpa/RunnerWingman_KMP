package com.wingman.shared.logic

import kotlinx.datetime.Clock

/**
 * Cronômetro puro Kotlin — equivalente ao StopWatchManager.swift.
 * Usa kotlinx-datetime (Clock.System) em vez de Foundation.Date.
 *
 * NOTA: Este é um objeto de lógica, não um @Observable/@Published.
 * A ViewModel Swift encapsula uma instância e publica as mudanças via SwiftUI.
 */
class StopWatch {

    // MARK: - State

    private var startTimeMs: Long? = null
    private var accumulatedMs: Long = 0
    private var _isRunning: Boolean = false

    val isRunning: Boolean get() = _isRunning

    // MARK: - API

    /**
     * Retorna o tempo decorrido em segundos.
     * Deve ser chamado periodicamente pela View/ViewModel para atualizar a UI.
     */
    val elapsedSeconds: Double
        get() {
            val running = if (_isRunning && startTimeMs != null) {
                Clock.System.now().toEpochMilliseconds() - startTimeMs!!
            } else {
                0L
            }
            return (accumulatedMs + running) / 1000.0
        }

    /**
     * Retorna o tempo formatado em "mm:ss".
     */
    val formatted: String
        get() = TimeFormatters.mmssFormatted(elapsedSeconds)

    fun start() {
        if (_isRunning) return
        startTimeMs = Clock.System.now().toEpochMilliseconds()
        _isRunning = true
    }

    fun stop() {
        if (!_isRunning) return
        val now = Clock.System.now().toEpochMilliseconds()
        val running = if (startTimeMs != null) now - startTimeMs!! else 0L
        accumulatedMs += running
        startTimeMs = null
        _isRunning = false
    }

    fun pause() {
        if (_isRunning) stop()
    }

    fun reset() {
        stop()
        accumulatedMs = 0
    }
}
