package com.wingman.shared.logic

import com.wingman.shared.model.RoutePoint
import kotlin.math.*

/**
 * Cálculos de rota — distância total usando Haversine.
 * Equivalente ao totalDistanceMeters do RecordingMapView.swift,
 * mas aqui sem depender de CLLocation.
 */
object RouteCalculations {

    private const val EARTH_RADIUS_METERS = 6_371_000.0

    /**
     * Calcula a distância total percorrida (em metros) a partir
     * de uma lista ordenada de pontos.
     */
    fun totalDistanceMeters(points: List<RoutePoint>): Double {
        if (points.size < 2) return 0.0

        var total = 0.0
        for (i in 1 until points.size) {
            total += haversineDistance(
                lat1 = points[i - 1].latitude,
                lon1 = points[i - 1].longitude,
                lat2 = points[i].latitude,
                lon2 = points[i].longitude
            )
        }
        return total
    }

    /**
     * Distância entre dois pontos usando Haversine (resultado em metros).
     */
    fun haversineDistance(
        lat1: Double, lon1: Double,
        lat2: Double, lon2: Double
    ): Double {
        val dLat = toRadians(lat2 - lat1)
        val dLon = toRadians(lon2 - lon1)
        val rLat1 = toRadians(lat1)
        val rLat2 = toRadians(lat2)

        val a = sin(dLat / 2).pow(2) +
                cos(rLat1) * cos(rLat2) * sin(dLon / 2).pow(2)
        val c = 2 * asin(sqrt(a))

        return EARTH_RADIUS_METERS * c
    }

    private fun toRadians(degrees: Double): Double = degrees * PI / 180.0
}
