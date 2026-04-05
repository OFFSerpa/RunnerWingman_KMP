package com.wingman.shared.model

/**
 * Ponto de coordenada gravado durante o rastreamento.
 */
data class RoutePoint(
    val latitude: Double,
    val longitude: Double,
    val timestamp: Long
)
