package com.wingman.shared.model

/**
 * Modelo de domínio puro para representar uma rota gravada.
 * Sem dependência de plataforma — usado pelo shared module.
 */
data class Route(
    val id: String,
    val name: String,
    val distanceMeters: Double,
    val bestLapSeconds: Double,
    val createdAtTimestamp: Long,
    val points: List<RoutePoint> = emptyList()
)
