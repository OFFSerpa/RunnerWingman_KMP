package com.wingman.shared.logic

/**
 * Utilitário de formatação de tempo — equivalente ao TimeFormatters.swift.
 */
object TimeFormatters {

    /**
     * Formata segundos em "m:ss" (ex: 125.0 → "2:05").
     */
    fun mmss(seconds: Double): String {
        val total = seconds.toInt()
        val minutes = total / 60
        val secs = total % 60
        return "$minutes:${secs.toString().padStart(2, '0')}"
    }

    /**
     * Formata segundos em "mm:ss" com minutos com zero à esquerda (ex: 65.0 → "01:05").
     */
    fun mmssFormatted(seconds: Double): String {
        val total = seconds.toInt()
        val minutes = total / 60
        val secs = total % 60
        return "${minutes.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}"
    }
}
