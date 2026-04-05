package com.wingman.shared

import com.wingman.shared.logic.TimeFormatters
import com.wingman.shared.logic.RouteCalculations
import com.wingman.shared.logic.StopWatch
import com.wingman.shared.model.RoutePoint
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertTrue
import kotlin.test.assertFalse

class TimeFormattersTest {

    @Test
    fun mmss_zeroSeconds() {
        assertEquals("0:00", TimeFormatters.mmss(0.0))
    }

    @Test
    fun mmss_lessThanOneMinute() {
        assertEquals("0:45", TimeFormatters.mmss(45.0))
    }

    @Test
    fun mmss_exactlyOneMinute() {
        assertEquals("1:00", TimeFormatters.mmss(60.0))
    }

    @Test
    fun mmss_twoMinutesFiveSeconds() {
        assertEquals("2:05", TimeFormatters.mmss(125.0))
    }

    @Test
    fun mmssFormatted_withLeadingZero() {
        assertEquals("01:05", TimeFormatters.mmssFormatted(65.0))
    }
}

class RouteCalculationsTest {

    @Test
    fun totalDistanceMeters_lessThanTwoPoints_returnsZero() {
        assertEquals(0.0, RouteCalculations.totalDistanceMeters(emptyList()))
        assertEquals(0.0, RouteCalculations.totalDistanceMeters(
            listOf(RoutePoint(0.0, 0.0, 0L))
        ))
    }

    @Test
    fun totalDistanceMeters_knownPoints() {
        // São Paulo → Rio de Janeiro ≈ 357 km (linha reta)
        val sp = RoutePoint(-23.5505, -46.6333, 0L)
        val rj = RoutePoint(-22.9068, -43.1729, 1L)
        val distance = RouteCalculations.totalDistanceMeters(listOf(sp, rj))

        // Tolerância de 5km para variação de Haversine
        assertTrue(distance > 352_000, "Distância SP-RJ deve ser > 352km, foi $distance")
        assertTrue(distance < 362_000, "Distância SP-RJ deve ser < 362km, foi $distance")
    }

    @Test
    fun haversineDistance_samePoint_returnsZero() {
        val d = RouteCalculations.haversineDistance(10.0, 20.0, 10.0, 20.0)
        assertEquals(0.0, d, 0.001)
    }
}

class StopWatchTest {

    @Test
    fun initialState_notRunning() {
        val sw = StopWatch()
        assertFalse(sw.isRunning)
        assertEquals(0.0, sw.elapsedSeconds, 0.01)
    }

    @Test
    fun start_isRunning() {
        val sw = StopWatch()
        sw.start()
        assertTrue(sw.isRunning)
    }

    @Test
    fun stop_notRunning() {
        val sw = StopWatch()
        sw.start()
        sw.stop()
        assertFalse(sw.isRunning)
    }

    @Test
    fun reset_clearsElapsed() {
        val sw = StopWatch()
        sw.start()
        sw.stop()
        sw.reset()
        assertFalse(sw.isRunning)
        assertEquals(0.0, sw.elapsedSeconds, 0.01)
    }

    @Test
    fun formatted_showsMmss() {
        val sw = StopWatch()
        // When not started, should be "00:00"
        assertEquals("00:00", sw.formatted)
    }
}
